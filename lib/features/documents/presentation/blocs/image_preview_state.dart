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

  ImagePreviewSuccess({required this.images});

  @override
  List<Object> get props => [images];
}

final class ImagePreviewFail extends ImagePreviewState {
  @override
  List<Object> get props => [];
}
