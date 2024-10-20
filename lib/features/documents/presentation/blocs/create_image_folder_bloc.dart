import 'package:bloc/bloc.dart';
import 'package:document_scanner/features/auth/core/services/cloud_firestore_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'create_image_folder_event.dart';
part 'create_image_folder_state.dart';

class CreateImageFolderBloc
    extends Bloc<CreateImageFolderEvent, CreateImageFolderState> {
  final CloudFirestoreService _firestore = CloudFirestoreService();

  CreateImageFolderBloc() : super(CreateImageFolderInitial()) {
    on<CreateImageFolderStarted>(_createImageFolder);
  }

  void _createImageFolder(
    CreateImageFolderStarted event,
    Emitter<CreateImageFolderState> emit,
  ) async {
    emit(CreateImageFolderInProgress());
    EasyLoading.show();
    await _firestore.newImageFolder();
    EasyLoading.dismiss();
    emit(CreateImageFolderSuccess());
  }
}
