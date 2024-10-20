import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:document_scanner/common/classes/get_scanned_document.dart';
import 'package:document_scanner/common/classes/save_image_class.dart';
import 'package:document_scanner/features/auth/core/services/firebase_auth_services.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path/path.dart' as p;

part 'upload_scanned_documents_event.dart';
part 'upload_scanned_documents_state.dart';

class UploadScannedDocumentsBloc
    extends Bloc<UploadScannedDocumentsEvent, UploadScannedDocumentsState> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  UploadScannedDocumentsBloc() : super(UploadScannedDocumentsInitial()) {
    on<UploadScannedDocumentsStarted>(_uploadScannedDocuments);
  }

  void _uploadScannedDocuments(
    UploadScannedDocumentsStarted event,
    Emitter<UploadScannedDocumentsState> emit,
  ) async {
    List<String> pictures = event.pictures;

    User? user = _auth.auth.currentUser;
    final storageRef = FirebaseStorage.instance.ref();

    if (user != null) {
      final String documentName =
          DateTime.now().microsecondsSinceEpoch.toString();

      final String imageUserPath =
          "images/scanned_documents/${user.uid}/$documentName";

      final List<GetScannedDocument> documents = [];
      final List<String> images = [];
      final List<String> pdfs = [];

      PdfDocument pdfDocument = PdfDocument();

      for (var (index, picture) in pictures.indexed) {
        final File image = File(picture);
        UploadTask? uploadImagesTask;

        final String imagePath = "$imageUserPath/$documentName.$index.jpg";

        final imageStorage = storageRef.child(imagePath);

        uploadImagesTask = imageStorage.putFile(image);

        uploadImagesTask.snapshotEvents.listen((event) {
          double progress =
              event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
          EasyLoading.showProgress(progress,
              status: '${(progress * 100).round()}%');
        }).onError((error) {
          throw Exception('Something went wrong uploading image.');
        });

        TaskSnapshot imageSnapshot =
            await uploadImagesTask.whenComplete(() async {
          EasyLoading.dismiss();
        });

        var imageDownloadUrl = await imageSnapshot.ref.getDownloadURL();
        images.add(imageDownloadUrl);

        PdfPage page = pdfDocument.pages.add();

        final PdfImage pdfImage = PdfBitmap(image.readAsBytesSync());

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

      // PDF Process
      final String pdfUserPath = "pdf/scanned_documents/${user.uid}";
      final String pdfPath = "$pdfUserPath/$documentName.pdf";
      final pdfRef = storageRef.child(pdfPath);
      UploadTask? pdfUploadTask;

      List<int> bytes = await pdfDocument.save();

      final File pdfFile =
          await SaveFile.bytesToFile(bytes, "$documentName.pdf");

      pdfUploadTask = pdfRef.putFile(pdfFile);

      pdfUploadTask.snapshotEvents.listen((event) {
        double progress =
            event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
        EasyLoading.showProgress(progress,
            status: '${(progress * 100).round()}%');
      }).onError((error) {
        throw Exception('Something went wrong uploading pdf.');
      });

      TaskSnapshot pdfSnapshot = await pdfUploadTask.whenComplete(() {
        EasyLoading.dismiss();
      });

      var pdfDownloadUrl = await pdfSnapshot.ref.getDownloadURL();
      pdfs.add(pdfDownloadUrl);

      pdfDocument.dispose();

      documents.add(GetScannedDocument(
        name: documentName,
        image: images.first,
        pdf: pdfDownloadUrl,
      ));

      emit(
        UploadScannedDocumentsSuccess(
          documents: documents,
          images: images,
          pdfs: pdfs,
        ),
      );
    } else {
      emit(UploadScannedDocumentsFail(message: "User not found."));
    }

    emit(UploadScannedDocumentsInProgress());
  }
}
