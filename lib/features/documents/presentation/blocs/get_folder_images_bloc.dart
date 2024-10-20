import 'package:bloc/bloc.dart';
import 'package:document_scanner/features/auth/core/services/firebase_auth_services.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'get_folder_images_event.dart';
part 'get_folder_images_state.dart';

class GetFolderImagesBloc
    extends Bloc<GetFolderImagesEvent, GetFolderImagesState> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  GetFolderImagesBloc() : super(GetFolderImagesInitial()) {
    on<GetFolderImageStarted>(_getFolderImage);
  }

  void _getFolderImage(
    GetFolderImageStarted event,
    Emitter<GetFolderImagesState> emit,
  ) async {
    emit(GetFolderImagesInProgress());
    EasyLoading.show();

    User? user = _auth.auth.currentUser;
    final List<String> images = [];

    if (user != null) {
      final String folderUserPath =
          "images/folders/${user.uid}/${event.folderId}";

      final folderStorage = FirebaseStorage.instance.ref(folderUserPath);

      ListResult documentResult = await folderStorage.listAll();

      for (Reference documentRef in documentResult.prefixes) {
        ListResult imageResult = await documentRef.listAll();

        for (Reference imageRef in imageResult.items) {
          final imageUrl = await imageRef.getDownloadURL();
          images.add(imageUrl);
        }
      }
    }

    EasyLoading.dismiss();
    emit(GetFolderImagesSuccess(images: images));
  }
}
