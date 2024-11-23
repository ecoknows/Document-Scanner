import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:document_scanner/common/classes/get_scanned_document.dart';
import 'package:document_scanner/common/classes/get_scanned_document_offline.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:equatable/equatable.dart';

part 'pdf_preview_event.dart';
part 'pdf_preview_state.dart';

class PdfPreviewBloc extends Bloc<PdfPreviewEvent, PdfPreviewState> {
  PdfPreviewBloc() : super(PdfPreviewInitial()) {
    on<PdfPreviewStarted>(_pdfPreviewStarted);
    on<PdfPreviewOfflineStarted>(_pdfPreviewOfflineStarted);
  }

  Future<void> _pdfPreviewStarted(
    PdfPreviewStarted event,
    Emitter<PdfPreviewState> emit,
  ) async {
    emit(PdfPreviewInProgress());

    PDFDocument pdfDocument = await PDFDocument.fromURL(event.document.pdf);

    emit(
      PdfPreviewSuccess(
        document: event.document,
        pdfDocument: pdfDocument,
      ),
    );
  }

  Future<void> _pdfPreviewOfflineStarted(
    PdfPreviewOfflineStarted event,
    Emitter<PdfPreviewState> emit,
  ) async {
    emit(PdfPreviewInProgress());

    PDFDocument pdfDocument = await PDFDocument.fromFile(event.document.pdf);

    emit(
      PdfPreviewOfflineSuccess(
        document: event.document,
        pdfDocument: pdfDocument,
      ),
    );
  }
}
