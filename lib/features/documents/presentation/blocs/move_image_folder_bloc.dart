import 'package:bloc/bloc.dart';
import 'package:document_scanner/features/auth/core/services/firebase_auth_services.dart';
import 'package:document_scanner/features/documents/core/image_folder.dart';
import 'package:document_scanner/features/documents/core/string_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'move_image_folder_event.dart';
part 'move_image_folder_state.dart';

class MoveImageFolderBloc
    extends Bloc<MoveImageFolderEvent, MoveImageFolderState> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  MoveImageFolderBloc() : super(MoveImageFolderInitial()) {
    on<MoveImageFolderStarted>(_moveImageFolder);
  }

  void _moveImageFolder(
    MoveImageFolderStarted event,
    Emitter<MoveImageFolderState> emit,
  ) async {
    User? user = _auth.auth.currentUser;

    emit(MoveImageFolderInProgress());

    if (user != null) {
      for (var (index, image) in event.images.indexed) {
        String documentName = StringHelper.getDocumentName(image);
        String fileName = event.imagesFilename[index];

        final fileRef = FirebaseStorage.instance.ref(
            "images/scanned_documents/${user.uid}/$documentName/$fileName");

        final data = await fileRef.getData();

        final newFileRef = FirebaseStorage.instance.ref(
            "images/folders/${user.uid}/${event.folder.id}/$documentName/$fileName");

        if (data != null) {
          newFileRef.putData(data);
          fileRef.delete();
        }
      }
    }

    emit(MoveImageFolderSuccess());
  }
}
