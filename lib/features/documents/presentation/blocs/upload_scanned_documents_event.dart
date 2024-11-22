part of 'upload_scanned_documents_bloc.dart';

sealed class UploadScannedDocumentsEvent extends Equatable {}

final class UploadScannedDocumentsStarted extends UploadScannedDocumentsEvent {
  final List<String> pictures;

  UploadScannedDocumentsStarted({required this.pictures});

  @override
  List<Object?> get props => [pictures];
}

final class UploadScannedDocumentsOfflineStarted
    extends UploadScannedDocumentsEvent {
  final List<String> pictures;

  UploadScannedDocumentsOfflineStarted({required this.pictures});

  @override
  List<Object?> get props => [pictures];
}
