part of 'pdf_preview_bloc.dart';

sealed class PdfPreviewState extends Equatable {}

final class PdfPreviewInitial extends PdfPreviewState {
  PdfPreviewInitial();

  @override
  List<Object> get props => [];
}

final class PdfPreviewInProgress extends PdfPreviewState {
  @override
  List<Object> get props => [];
}

final class PdfPreviewSuccess extends PdfPreviewState {
  final GetScannedDocument document;
  final PDFDocument pdfDocument;

  PdfPreviewSuccess({
    required this.document,
    required this.pdfDocument,
  });

  @override
  List<Object> get props => [];
}

final class PdfPreviewOfflineSuccess extends PdfPreviewState {
  final GetScannedDocumentOffline document;
  final PDFDocument pdfDocument;

  PdfPreviewOfflineSuccess({
    required this.document,
    required this.pdfDocument,
  });

  @override
  List<Object> get props => [];
}

final class PdfPreviewFail extends PdfPreviewState {
  PdfPreviewFail();

  @override
  List<Object> get props => [];
}
