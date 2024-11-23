import 'package:bloc/bloc.dart';
import 'package:document_scanner/features/auth/core/services/firebase_auth_services.dart';
import 'package:document_scanner/features/documents/core/string_helper.dart';
import 'package:document_scanner/features/documents/data/entities/document_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'delete_document_event.dart';
part 'delete_document_state.dart';

class DeleteDocumentBloc
    extends Bloc<DeleteDocumentEvent, DeleteDocumentState> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  DeleteDocumentBloc() : super(DeleteDocumentInitial()) {
    on<DeleteImageStarted>(_deleteImageStarted);
    on<DeleteImageOfflineStarted>(_deleteImageOfflineStarted);
    on<DeletePdfOfflineStarted>(_deletePdfOfflineStarted);
    on<DeletePdfStarted>(_deletePdfStarted);
  }

  Future<void> _deleteImageStarted(
    DeleteImageStarted event,
    Emitter<DeleteDocumentState> emit,
  ) async {
    emit(DeleteDocumentInProgress());

    User? user = _auth.auth.currentUser;
    final storageRef = FirebaseStorage.instance.ref();

    if (user != null) {
      EasyLoading.show();

      String folderName = StringHelper.extractFileName(event.fileName);

      final String imageUserPath =
          "images/scanned_documents/${user.uid}/$folderName/${event.fileName}";

      final imageStorage = storageRef.child(imageUserPath);

      await imageStorage.delete();

      EasyLoading.dismiss();
    }

    emit(DeleteDocumentSuccess(isOffline: false));
  }

  Future<void> _deleteImageOfflineStarted(
    DeleteImageOfflineStarted event,
    Emitter<DeleteDocumentState> emit,
  ) async {
    emit(DeleteDocumentInProgress());

    DocumentModel document = event.document;

    document.images.removeWhere((element) => element.name == event.fileName);

    document.save();

    emit(DeleteDocumentSuccess(isOffline: true));
  }

  Future<void> _deletePdfOfflineStarted(
    DeletePdfOfflineStarted event,
    Emitter<DeleteDocumentState> emit,
  ) async {
    emit(DeleteDocumentInProgress());

    DocumentModel document = event.document;

    document.delete();

    emit(DeleteDocumentSuccess(isOffline: true));
  }

  Future<void> _deletePdfStarted(
    DeletePdfStarted event,
    Emitter<DeleteDocumentState> emit,
  ) async {
    emit(DeleteDocumentInProgress());

    User? user = _auth.auth.currentUser;
    final storageRef = FirebaseStorage.instance.ref();

    if (user != null) {
      EasyLoading.show();

      final String pdfUserPath =
          "pdf/scanned_documents/${user.uid}/${event.fileName}.pdf";

      final String pdImagefUserPath =
          "pdf/scanned_image/${user.uid}/${event.fileName}.jpg";

      final pdfUserStorage = storageRef.child(pdfUserPath);
      await pdfUserStorage.delete();

      final pdfImageStorage = storageRef.child(pdImagefUserPath);
      await pdfImageStorage.delete();

      EasyLoading.dismiss();
    }

    emit(DeleteDocumentSuccess(isOffline: false));
  }
}
