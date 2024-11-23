import 'package:bloc/bloc.dart';
import 'package:document_scanner/common/classes/firebase_helpers.dart';
import 'package:document_scanner/common/classes/get_scanned_document.dart';
import 'package:document_scanner/features/auth/core/services/firebase_auth_services.dart';
import 'package:document_scanner/features/documents/core/image_folder.dart';
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

    EasyLoading.show();

    if (user != null) {
      for (var image in event.images) {
        GetScannedDocument document =
            event.documents.firstWhere((element) => element.image == image);

        final imageFolderRef = FirebaseStorage.instance
            .ref("images/scanned_documents/${user.uid}/${document.name}");

        final folder = await imageFolderRef.listAll();

        for (var (index, item) in folder.items.indexed) {
          final data = await item.getData();

          if (data != null) {
            final newFileRef = FirebaseStorage.instance.ref(
                "images/folders/${user.uid}/${event.folder.id}/${document.name}/${document.name}.$index.jpg");

            await newFileRef.putData(data);

            await FirebaseHelpers.renameFile(
              "images/scanned_documents/${user.uid}/${document.name}/${document.name}.$index.jpg",
              "images/scanned_documents/${user.uid}/${document.name}/${document.name}.$index.moved.jpg",
            );
          }
        }
      }
    }

    EasyLoading.dismiss();
    emit(MoveImageFolderSuccess());
  }
}
