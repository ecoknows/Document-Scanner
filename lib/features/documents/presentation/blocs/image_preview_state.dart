part of 'image_preview_bloc.dart';

sealed class ImagePreviewState extends Equatable {}

final class ImagePreviewInitial extends ImagePreviewState {
  @override
  List<Object> get props => [];
}

final class ImagePreviewInProgress extends ImagePreviewState {
  @override
  List<Object> get props => [];
}

final class ImagePreviewSuccess extends ImagePreviewState {
  final List<String> images;
  final List<String> imagesFilename;

  ImagePreviewSuccess({
    required this.images,
    required this.imagesFilename,
  });

  @override
  List<Object> get props => [
        images,
        imagesFilename,
      ];
}

final class ImagePreviewOfflineSuccess extends ImagePreviewState {
  final List<String> images;
  final List<GetScannedDocumentOffline> documents;

  ImagePreviewOfflineSuccess({
    required this.images,
    required this.documents,
  });

  @override
  List<Object> get props => [
        images,
        documents,
      ];
}

final class ImagePreviewFail extends ImagePreviewState {
  @override
  List<Object> get props => [];
}
