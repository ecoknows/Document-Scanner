part of 'move_image_folder_bloc.dart';

sealed class MoveImageFolderEvent extends Equatable {}

final class MoveImageFolderStarted extends MoveImageFolderEvent {
  final ImageFolder folder;
  final List<GetScannedDocument> documents;
  final List<String> images;
  final List<String> imagesFilename;

  MoveImageFolderStarted({
    required this.folder,
    required this.documents,
    required this.images,
    required this.imagesFilename,
  });

  @override
  List<Object?> get props => [images];
}
