import 'package:bloc/bloc.dart';
import 'package:document_scanner/common/classes/get_scanned_document.dart';
import 'package:document_scanner/features/auth/core/services/firebase_services.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

part 'get_scanned_documents_event.dart';
part 'get_scanned_documents_state.dart';

class GetScannedDocumentsBloc
    extends Bloc<GetScannedDocumentsEvent, GetScannedDocumentsState> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  GetScannedDocumentsBloc() : super(GetScannedDocumentsInitial()) {
    on<GetScannedDocumentsStarted>(_getScannedDocuments);
    on<AddScannedDocumentsStarted>(_addScannedDocuments);
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

      ListResult documentResult = await documentStorage.listAll();

      for (Reference documentRef in documentResult.prefixes) {
        ListResult imageResult = await documentRef.listAll();

        for (Reference imageRef in imageResult.items) {
          final imageUrl = await imageRef.getDownloadURL();
          images.add(imageUrl);
        }
      }

      final pdfStorage = FirebaseStorage.instance.ref().child(pdfsUserPath);
      ListResult pdfResult = await pdfStorage.listAll();

      for (Reference pdfRef in pdfResult.items) {
        final pdfUrl = await pdfRef.getDownloadURL();
        final pdfName = pdfRef.name.split(".").first;
        final imagePath = "$documentsUserPath/$pdfName/$pdfName.0.jpg";

        final document = GetScannedDocument(
          name: pdfRef.name.split(".").first,
          image: await FirebaseStorage.instance.ref(imagePath).getDownloadURL(),
          pdf: pdfUrl,
        );

        pdfs.add(pdfUrl);
        documents.add(document);
      }

      emit(GetScannedDocumentsSuccess(
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
      List<GetScannedDocument> documents = List.from(currentState.documents);
      List<String> images = List.from(currentState.images);
      List<String> pdfs = List.from(currentState.pdfs);

      documents.addAll(event.documents);
      images.addAll(event.images);
      pdfs.addAll(event.pdfs);

      emit(GetScannedDocumentsSuccess(
          documents: documents, images: images, pdfs: pdfs));
    }
  }
}
