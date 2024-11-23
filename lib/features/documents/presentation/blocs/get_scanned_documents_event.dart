part of 'get_scanned_documents_bloc.dart';

sealed class GetScannedDocumentsEvent extends Equatable {}

final class GetScannedDocumentsStarted extends GetScannedDocumentsEvent {
  final bool showLoadingIndicator;

  GetScannedDocumentsStarted({required this.showLoadingIndicator});

  @override
  List<Object?> get props => [showLoadingIndicator];
}

final class GetScannedDocumentsOfflineStarted extends GetScannedDocumentsEvent {
  final bool showLoadingIndicator;

  GetScannedDocumentsOfflineStarted({required this.showLoadingIndicator});
  @override
  List<Object?> get props => [];
}

final class AddScannedDocumentsStarted extends GetScannedDocumentsEvent {
  final List<GetScannedDocument> documents;
  final List<String> images;
  final List<String> imagesFilename;
  final List<String> pdfs;

  AddScannedDocumentsStarted({
    required this.documents,
    required this.images,
    required this.imagesFilename,
    required this.pdfs,
  });

  @override
  List<Object?> get props => [documents, images, imagesFilename, pdfs];
}

final class RemoveImagesStarted extends GetScannedDocumentsEvent {
  final List<String> images;
  final List<String> imagesFilename;

  RemoveImagesStarted({
    required this.images,
    required this.imagesFilename,
  });

  @override
  List<Object?> get props => [images, imagesFilename];
}

final class AddScannedDocumentsOfflineStarted extends GetScannedDocumentsEvent {
  final DocumentModel document;

  AddScannedDocumentsOfflineStarted({
    required this.document,
  });

  @override
  List<Object?> get props => [document];
}
