import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:document_scanner/features/auth/core/services/firebase_services.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

    if (user != null) {
      final String userPath = "images/scanned_documents/${user.uid}";
      final List<String> latestUpladedDocuments = [];

      for (String picture in pictures) {
        final String extension = p.extension(picture);
        final File image = File(picture);
        UploadTask? uploadTask;

        final String imageName =
            DateTime.now().microsecondsSinceEpoch.toString();

        final String imagePath = "$userPath/$imageName$extension";

        final ref = FirebaseStorage.instance.ref().child(imagePath);

        uploadTask = ref.putFile(image);

        uploadTask.snapshotEvents.listen((event) {
          double progress =
              event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
          EasyLoading.showProgress(progress,
              status: '${(progress * 100).round()}%');
        }).onError((error) {
          throw Exception('Something went wrong uploading image.');
        });

        TaskSnapshot snapshot = await uploadTask.whenComplete(() => {
              EasyLoading.dismiss(),
            });

        latestUpladedDocuments.add(await snapshot.ref.getDownloadURL());
      }

      emit(
        UploadScannedDocumentsSuccess(
          latestUploaded: latestUpladedDocuments,
        ),
      );
    } else {
      emit(UploadScannedDocumentsFail(message: "User not found."));
    }

    emit(UploadScannedDocumentsInProgress());
  }
}
