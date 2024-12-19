import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:document_scanner/common/classes/get_scanned_document.dart';
import 'package:document_scanner/common/classes/save_image_class.dart';
import 'package:document_scanner/features/auth/core/services/firebase_auth_services.dart';
import 'package:document_scanner/features/documents/data/entities/document_model.dart';
import 'package:document_scanner/features/documents/data/entities/image_model.dart';
import 'package:document_scanner/features/documents/data/entities/pdf_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path/path.dart' as p;

part 'upload_scanned_documents_event.dart';
part 'upload_scanned_documents_state.dart';

class UploadScannedDocumentsBloc
    extends Bloc<UploadScannedDocumentsEvent, UploadScannedDocumentsState> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  UploadScannedDocumentsBloc() : super(UploadScannedDocumentsInitial()) {
    on<UploadScannedDocumentsStarted>(_uploadScannedDocuments);
    on<UploadScannedDocumentsOfflineStarted>(_uploadScannedDocumentsOffline);
  }

  void _uploadScannedDocumentsOffline(
    UploadScannedDocumentsOfflineStarted event,
    Emitter<UploadScannedDocumentsState> emit,
  ) async {
    final box = await Hive.openBox<DocumentModel>('documentsBox');

    List<String> pictures = event.pictures;

    final String documentName =
        DateTime.now().microsecondsSinceEpoch.toString();

    PdfDocument pdfDocument = PdfDocument();

    List<ImageModel> images = [];

    for (var (index, picture) in pictures.indexed) {
      Uint8List bytes = await File(picture).readAsBytes();

      images.add(
        ImageModel(
          name: "$documentName.$index.jpg",
          bytes: bytes,
          isUploaded: false,
        ),
      );

      PdfPage page = pdfDocument.pages.add();

      final PdfImage pdfImage = PdfBitmap(bytes);

      page.graphics.drawImage(
        pdfImage,
        Rect.fromLTWH(
          0,
          0,
          page.size.width,
          page.size.height,
        ),
      );
    }

    List<int> pdfInt = await pdfDocument.save();
    final File pdfFile =
        await SaveFile.bytesToFile(pdfInt, "$documentName.pdf");

    Uint8List bytes = await pdfFile.readAsBytes();

    PdfModel pdf = PdfModel(
      name: "$documentName.pdf",
      imageBytes: images.first.bytes,
      bytes: bytes,
      isUploaded: false,
    );

    pdfDocument.dispose();

    final document = DocumentModel(
      name: documentName,
      images: images,
      pdf: pdf,
    );

    await box.add(document);

    emit(UploadScannedDocumentsOfflineSuccess(document: document));
  }

  void _uploadScannedDocuments(
    UploadScannedDocumentsStarted event,
    Emitter<UploadScannedDocumentsState> emit,
  ) async {
    List<String> pictures = event.pictures;

    User? user = _auth.auth.currentUser;
    final storageRef = FirebaseStorage.instance.ref();

    if (user != null) {
      final String documentName = event.documentName;

      final String imageUserPath =
          "images/scanned_documents/${user.uid}/$documentName";

      final List<String> images = [];
      final List<String> imagesFilename = [];

      emit(UploadScannedDocumentsInProgress());

      // Use Future.wait for parallel uploads
      try {
        final List<Future<void>> uploadTasks =
            pictures.asMap().entries.map((entry) async {
          int index = entry.key;
          String picture = entry.value;

          final File image = File(picture);

          final String imageName = "$documentName.$index.jpg";
          imagesFilename.add(imageName);

          final String imagePath = "$imageUserPath/$imageName";
          final imageStorage = storageRef.child(imagePath);

          UploadTask uploadTask = imageStorage.putFile(image);

          // Track progress for each upload
          uploadTask.snapshotEvents.listen((event) {
            double progress =
                event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
            EasyLoading.showProgress(progress,
                status: 'Uploading $index: ${(progress * 100).round()}%');
          }).onError((error) {
            throw Exception('Something went wrong uploading image $index.');
          });

          TaskSnapshot snapshot = await uploadTask;
          var downloadUrl = await snapshot.ref.getDownloadURL();
          images.add(downloadUrl);
        }).toList();

        await Future.wait(uploadTasks);

        emit(UploadScannedDocumentsSuccess(
          images: images,
          imagesFilename: imagesFilename,
        ));
      } catch (e) {
        emit(UploadScannedDocumentsFail(message: "Error uploading images: $e"));
      } finally {
        EasyLoading.dismiss();
      }
    } else {
      emit(UploadScannedDocumentsFail(message: "User not found."));
    }
  }
}
