import 'package:bloc/bloc.dart';
import 'package:document_scanner/features/auth/core/services/cloud_firestore_services.dart';
import 'package:equatable/equatable.dart';

part 'rename_folder_event.dart';
part 'rename_folder_state.dart';

class RenameFolderBloc extends Bloc<RenameFolderEvent, RenameFolderState> {
  final CloudFirestoreService _firestore = CloudFirestoreService();

  RenameFolderBloc() : super(RenameFolderInitial()) {
    on<RenameFolderStarted>(_renameFolder);
  }

  void _renameFolder(
    RenameFolderStarted event,
    Emitter<RenameFolderState> emit,
  ) async {
    emit(RenameFolderInProgress());
    await _firestore.renameFolder(event.folderId, event.name);
    emit(RenameFolderSuccess());
  }
}
