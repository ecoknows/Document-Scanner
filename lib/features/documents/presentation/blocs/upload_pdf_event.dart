part of 'upload_pdf_bloc.dart';

sealed class UploadPdfEvent extends Equatable {}

final class UploadPdfStarted extends UploadPdfEvent {
  final List<String> pictures;
  final String documentName;

  UploadPdfStarted({required this.pictures, required this.documentName});

  @override
  List<Object> get props => [pictures, documentName];
}
