import 'package:bloc/bloc.dart';
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
      final String userPath = "images/scanned_documents/${user.uid}";
      final storage = FirebaseStorage.instance.ref().child(userPath);
      final List<String> documents = [];

      GetScannedDocumentsInProgress();

      ListResult listResult = await storage.listAll();

      for (Reference ref in listResult.items) {
        documents.add(await ref.getDownloadURL());
      }

      emit(GetScannedDocumentsSuccess(documents: documents));
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
      List<String> copiedListDocuments = List.from(currentState.documents);

      copiedListDocuments.addAll(event.scannedDocuments);
      emit(GetScannedDocumentsSuccess(documents: copiedListDocuments));
    }
  }
}
