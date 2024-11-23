part of 'image_preview_bloc.dart';

sealed class ImagePreviewEvent extends Equatable {}

final class ImagePreviewStarted extends ImagePreviewEvent {
  final List<String> images;
  final List<String> imagesFilename;

  ImagePreviewStarted({
    required this.images,
    required this.imagesFilename,
  });

  @override
  List<Object> get props => [
        images,
        imagesFilename,
      ];
}

final class ImagePreviewOfflineStarted extends ImagePreviewEvent {
  final List<String> images;
  final List<GetScannedDocumentOffline> documents;

  ImagePreviewOfflineStarted({
    required this.images,
    required this.documents,
  });

  @override
  List<Object> get props => [images];
}
