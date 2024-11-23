part of 'upload_scanned_documents_bloc.dart';

sealed class UploadScannedDocumentsState extends Equatable {}

final class UploadScannedDocumentsInitial extends UploadScannedDocumentsState {
  @override
  List<Object?> get props => [];
}

final class UploadScannedDocumentsInProgress
    extends UploadScannedDocumentsState {
  @override
  List<Object?> get props => [];
}

final class UploadScannedDocumentsSuccess extends UploadScannedDocumentsState {
  final List<GetScannedDocument> documents;
  final List<String> images;
  final List<String> imagesFilename;
  final List<String> pdfs;

  UploadScannedDocumentsSuccess({
    required this.documents,
    required this.images,
    required this.imagesFilename,
    required this.pdfs,
  });

  @override
  List<Object?> get props => [documents, images, pdfs];
}

final class UploadScannedDocumentsOfflineSuccess
    extends UploadScannedDocumentsState {
  final DocumentModel document;

  UploadScannedDocumentsOfflineSuccess({
    required this.document,
  });

  @override
  List<Object?> get props => [
        document,
      ];
}

final class UploadScannedDocumentsFail extends UploadScannedDocumentsState {
  final String message;

  UploadScannedDocumentsFail({required this.message});

  @override
  List<Object?> get props => [];
}
