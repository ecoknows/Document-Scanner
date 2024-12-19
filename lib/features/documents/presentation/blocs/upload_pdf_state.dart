part of 'upload_pdf_bloc.dart';

sealed class UploadPdfState extends Equatable {}

final class UploadPdfInitial extends UploadPdfState {
  UploadPdfInitial();

  @override
  List<Object> get props => [];
}

final class UploadPdfInProgress extends UploadPdfState {
  UploadPdfInProgress();

  @override
  List<Object> get props => [];
}

final class UploadPdfSuccess extends UploadPdfState {
  UploadPdfSuccess();

  @override
  List<Object> get props => [];
}

final class UploadPdfFail extends UploadPdfState {
  UploadPdfFail();

  @override
  List<Object> get props => [];
}
