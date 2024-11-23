import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:document_scanner/common/classes/get_scanned_document.dart';
import 'package:document_scanner/common/classes/get_scanned_document_offline.dart';
import 'package:document_scanner/features/documents/data/entities/document_model.dart';
import 'package:equatable/equatable.dart';

part 'image_preview_event.dart';
part 'image_preview_state.dart';

class ImagePreviewBloc extends Bloc<ImagePreviewEvent, ImagePreviewState> {
  ImagePreviewBloc() : super(ImagePreviewInitial()) {
    on<ImagePreviewStarted>(_imagePreview);
    on<ImagePreviewOfflineStarted>(_imagePreviewOffline);
  }

  void _imagePreview(
    ImagePreviewStarted event,
    Emitter<ImagePreviewState> emit,
  ) {
    emit(ImagePreviewInProgress());
    emit(ImagePreviewSuccess(
      images: event.images,
      imagesFilename: event.imagesFilename,
    ));
  }

  void _imagePreviewOffline(
    ImagePreviewOfflineStarted event,
    Emitter<ImagePreviewState> emit,
  ) {
    emit(ImagePreviewInProgress());
    emit(
      ImagePreviewOfflineSuccess(
        images: event.images,
        documents: event.documents,
      ),
    );
  }
}
