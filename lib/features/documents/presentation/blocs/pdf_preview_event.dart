part of 'pdf_preview_bloc.dart';

sealed class PdfPreviewEvent extends Equatable {}

final class PdfPreviewStarted extends PdfPreviewEvent {
  GetScannedDocument document;

  PdfPreviewStarted({required this.document});

  @override
  List<Object> get props => [];
}

final class PdfPreviewOfflineStarted extends PdfPreviewEvent {
  GetScannedDocumentOffline document;

  PdfPreviewOfflineStarted({
    required this.document,
  });

  @override
  List<Object> get props => [document];
}
