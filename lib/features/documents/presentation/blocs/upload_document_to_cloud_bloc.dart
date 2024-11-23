import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:document_scanner/common/classes/save_image_class.dart';
import 'package:document_scanner/features/auth/core/services/firebase_auth_services.dart';
import 'package:document_scanner/features/documents/data/entities/document_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';

part 'upload_document_to_cloud_event.dart';
part 'upload_document_to_cloud_state.dart';

class UploadDocumentToCloudBloc
    extends Bloc<UploadDocumentToCloudEvent, UploadDocumentToCloudState> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  UploadDocumentToCloudBloc() : super(UploadDocumentToCloudInitial()) {
    on<UploadDocumentToCloudStarted>(_uploadToCloudStarted);
  }

  Future<void> _uploadToCloudStarted(
    UploadDocumentToCloudStarted event,
    Emitter<UploadDocumentToCloudState> emit,
  ) async {
    User? user = _auth.auth.currentUser;
    final storageRef = FirebaseStorage.instance.ref();

    emit(UploadDocumentToCloudInProgress());

    if (user != null) {
      final box = await Hive.openBox<DocumentModel>('documentsBox');

      final documents = box.values.toList();

      for (var (documentIndex, document) in documents.indexed) {
        final String imageFolderPath =
            "images/scanned_documents/${user.uid}/${document.name}";

        for (var (index, image) in document.images.indexed) {
          if (image.isUploaded) {
            continue;
          }

          final String imgName = "${document.name}.$index.jpg";
          final File imgFile =
              await SaveFile.uint8ListToFile(image.bytes, imgName);

          UploadTask? uploadImagesTask;

          final String imageCloudPath = "$imageFolderPath/$imgName";

          final imageCloudStorage = storageRef.child(imageCloudPath);

          uploadImagesTask = imageCloudStorage.putFile(imgFile);

          uploadImagesTask.snapshotEvents.listen((event) {
            double progress =
                event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
            EasyLoading.showProgress(progress,
                status: '${(progress * 100).round()}%');
          }).onError((error) {
            throw Exception('Something went wrong uploading image.');
          });

          await uploadImagesTask.whenComplete(() async {
            final documentToBeUpdated = document.copyWith();

            documentToBeUpdated.images[index].isUploaded = true;

            box.putAt(documentIndex, documentToBeUpdated);
            EasyLoading.dismiss();
          });
        }

        if (document.pdf.isUploaded) {
          continue;
        }

        final String pdfName = "${document.name}.pdf";
        final File pdfFile =
            await SaveFile.uint8ListToFile(document.pdf.bytes, pdfName);

        final String pdfFolderPath = "pdf/scanned_documents/${user.uid}";
        final String pdfCloudStoragePath = "$pdfFolderPath/$pdfName";

        final pdfCloudStorage = storageRef.child(pdfCloudStoragePath);
        UploadTask? pdfUploadTask;

        pdfUploadTask = pdfCloudStorage.putFile(pdfFile);

        pdfUploadTask.snapshotEvents.listen((event) {
          double progress =
              event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
          EasyLoading.showProgress(progress,
              status: '${(progress * 100).round()}%');
        }).onError((error) {
          throw Exception('Something went wrong uploading pdf.');
        });

        await pdfUploadTask.whenComplete(() {
          final documentToBeUpdated = document.copyWith();

          documentToBeUpdated.pdf.isUploaded = true;

          box.putAt(documentIndex, documentToBeUpdated);
          EasyLoading.dismiss();
        });
      }

      emit(UploadDocumentToCloudSuccess());
    }
  }
}
