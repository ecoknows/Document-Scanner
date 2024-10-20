import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'image_preview_event.dart';
part 'image_preview_state.dart';

class ImagePreviewBloc extends Bloc<ImagePreviewEvent, ImagePreviewState> {
  ImagePreviewBloc() : super(ImagePreviewInitial()) {
    on<ImagePreviewStarted>(_imagePreview);
  }

  void _imagePreview(
    ImagePreviewStarted event,
    Emitter<ImagePreviewState> emit,
  ) {
    emit(ImagePreviewInProgress());
    emit(ImagePreviewSuccess(images: event.images));
  }
}
