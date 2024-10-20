import 'package:bloc/bloc.dart';
import 'package:document_scanner/common/classes/firebase_helpers.dart';
import 'package:document_scanner/common/classes/get_scanned_document.dart';
import 'package:document_scanner/features/auth/core/services/cloud_firestore_services.dart';
import 'package:document_scanner/features/auth/core/services/firebase_auth_services.dart';
import 'package:document_scanner/features/documents/data/image_folder.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'get_scanned_documents_event.dart';
part 'get_scanned_documents_state.dart';

class GetScannedDocumentsBloc
    extends Bloc<GetScannedDocumentsEvent, GetScannedDocumentsState> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final CloudFirestoreService _firestore = CloudFirestoreService();

  GetScannedDocumentsBloc() : super(GetScannedDocumentsInitial()) {
    on<GetScannedDocumentsStarted>(_getScannedDocuments);
    on<AddScannedDocumentsStarted>(_addScannedDocuments);
    on<RemoveImagesStarted>(_removeImages);
  }

  void _getScannedDocuments(
    GetScannedDocumentsStarted event,
    Emitter<GetScannedDocumentsState> emit,
  ) async {
    User? user = _auth.auth.currentUser;

    if (user != null) {
      final List<GetScannedDocument> documents = [];
      final List<String> images = [];
      final List<String> pdfs = [];

      final String documentsUserPath = "images/scanned_documents/${user.uid}";
      final String pdfsUserPath = "pdf/scanned_documents/${user.uid}";

      final documentStorage = FirebaseStorage.instance.ref(documentsUserPath);

      GetScannedDocumentsInProgress();

      EasyLoading.show();

      ListResult documentResult = await documentStorage.listAll();

      for (Reference documentRef in documentResult.prefixes) {
        ListResult imageResult = await documentRef.listAll();

        for (Reference imageRef in imageResult.items) {
          if (!imageRef.name.contains("moved")) {
            final imageUrl = await imageRef.getDownloadURL();
            images.add(imageUrl);
          }
        }
      }

      final pdfStorage = FirebaseStorage.instance.ref().child(pdfsUserPath);
      ListResult pdfResult = await pdfStorage.listAll();

      for (Reference pdfRef in pdfResult.items) {
        final pdfUrl = await pdfRef.getDownloadURL();
        final pdfName = pdfRef.name.split(".").first;

        final imagePath = "$documentsUserPath/$pdfName/$pdfName.0.jpg";
        final imageDownload =
            await FirebaseHelpers.getDownloadUrlIfExists(imagePath);

        final imagePathMoved =
            "$documentsUserPath/$pdfName/$pdfName.0.moved.jpg";
        final imageMovedDownload =
            await FirebaseHelpers.getDownloadUrlIfExists(imagePathMoved);

        final document = GetScannedDocument(
          name: pdfRef.name.split(".").first,
          image: imageDownload ?? imageMovedDownload!,
          pdf: pdfUrl,
        );

        pdfs.add(pdfUrl);
        documents.add(document);
      }

      List<ImageFolder> imageFolders = await _firestore.getImageFolder();

      EasyLoading.dismiss();
      emit(GetScannedDocumentsSuccess(
        imageFolders: imageFolders,
        documents: documents,
        images: images,
        pdfs: pdfs,
      ));
    } else {
      emit(GetScannedDocumentsFail(message: "User not found."));
    }
  }

  void _addScannedDocuments(
    AddScannedDocumentsStarted event,
    Emitter<GetScannedDocumentsState> emit,
  ) {
    GetScannedDocumentsState currentState = state;

    if (currentState is GetScannedDocumentsSuccess) {
      List<ImageFolder> imageFolders = List.from(currentState.imageFolders);
      List<GetScannedDocument> documents = List.from(currentState.documents);
      List<String> images = List.from(currentState.images);
      List<String> pdfs = List.from(currentState.pdfs);

      documents.addAll(event.documents);
      images.addAll(event.images);
      pdfs.addAll(event.pdfs);

      emit(GetScannedDocumentsSuccess(
        imageFolders: imageFolders,
        documents: documents,
        images: images,
        pdfs: pdfs,
      ));
    }
  }

  void _removeImages(
    RemoveImagesStarted event,
    Emitter<GetScannedDocumentsState> emit,
  ) {
    GetScannedDocumentsState currentState = state;

    if (currentState is GetScannedDocumentsSuccess) {
      List<String> images = List.from(currentState.images);

      images.removeWhere((element) => event.images.contains(element));

      emit(GetScannedDocumentsSuccess(
        imageFolders: currentState.imageFolders,
        documents: currentState.documents,
        images: images,
        pdfs: currentState.pdfs,
      ));
    }
  }
}
