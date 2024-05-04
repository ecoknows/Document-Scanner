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
  final List<String> latestUploaded;

  UploadScannedDocumentsSuccess({required this.latestUploaded});

  @override
  List<Object?> get props => [];
}

final class UploadScannedDocumentsFail extends UploadScannedDocumentsState {
  final String message;

  UploadScannedDocumentsFail({required this.message});

  @override
  List<Object?> get props => [];
}
