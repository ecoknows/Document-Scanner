part of 'get_folder_images_bloc.dart';

sealed class GetFolderImagesState extends Equatable {}

final class GetFolderImagesInitial extends GetFolderImagesState {
  @override
  List<Object> get props => [];
}

final class GetFolderImagesInProgress extends GetFolderImagesState {
  @override
  List<Object> get props => [];
}

final class GetFolderImagesSuccess extends GetFolderImagesState {
  final List<String> images;
  final List<String> imagesFilename;

  GetFolderImagesSuccess({
    required this.images,
    required this.imagesFilename,
  });

  @override
  List<Object> get props => [];
}

final class GetFolderImagesFail extends GetFolderImagesState {
  @override
  List<Object> get props => [];
}
