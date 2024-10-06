part of 'get_scanned_documents_bloc.dart';

sealed class GetScannedDocumentsState extends Equatable {}

final class GetScannedDocumentsInitial extends GetScannedDocumentsState {
  @override
  List<Object?> get props => [];
}

final class GetScannedDocumentsInProgress extends GetScannedDocumentsState {
  @override
  List<Object?> get props => [];
}

final class GetScannedDocumentsSuccess extends GetScannedDocumentsState {
  final List<GetScannedDocument> documents;
  final List<String> images;
  final List<String> pdfs;

  GetScannedDocumentsSuccess({
    required this.documents,
    required this.images,
    required this.pdfs,
  });

  @override
  List<Object?> get props => [documents, images, pdfs];
}

final class GetScannedDocumentsFail extends GetScannedDocumentsState {
  final String message;

  GetScannedDocumentsFail({required this.message});

  @override
  List<Object?> get props => [message];
}
