part of 'image_preview_bloc.dart';

sealed class ImagePreviewEvent extends Equatable {}

final class ImagePreviewStarted extends ImagePreviewEvent {
  final List<String> images;

  ImagePreviewStarted({required this.images});

  @override
  List<Object> get props => [images];
}

final class ImagePreviewOfflineStarted extends ImagePreviewEvent {
  final List<File> images;

  ImagePreviewOfflineStarted({required this.images});

  @override
  List<Object> get props => [images];
}
