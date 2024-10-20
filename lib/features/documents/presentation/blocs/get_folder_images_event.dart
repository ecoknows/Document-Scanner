part of 'get_folder_images_bloc.dart';

sealed class GetFolderImagesEvent extends Equatable {}

final class GetFolderImageStarted extends GetFolderImagesEvent {
  final String folderId;

  GetFolderImageStarted({required this.folderId});

  @override
  List<Object> get props => [folderId];
}
