part of 'get_scanned_documents_bloc.dart';

sealed class GetScannedDocumentsEvent extends Equatable {}

final class GetScannedDocumentsStarted extends GetScannedDocumentsEvent {
  @override
  List<Object?> get props => [];
}

final class AddScannedDocumentsStarted extends GetScannedDocumentsEvent {
  final List<GetScannedDocument> documents;
  final List<String> images;
  final List<String> pdfs;

  AddScannedDocumentsStarted({
    required this.documents,
    required this.images,
    required this.pdfs,
  });

  @override
  List<Object?> get props => [documents, images, pdfs];
}
