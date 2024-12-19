part of 'delete_document_bloc.dart';

sealed class DeleteDocumentEvent extends Equatable {}

final class DeleteImagesStarted extends DeleteDocumentEvent {
  final List<String> fileNames;
  final String path;

  DeleteImagesStarted({
    required this.fileNames,
    this.path = "",
  });

  @override
  List<Object> get props => [fileNames, path];
}

final class DeleteImageOfflineStarted extends DeleteDocumentEvent {
  final DocumentModel document;
  final String fileName;

  DeleteImageOfflineStarted({
    required this.document,
    required this.fileName,
  });

  @override
  List<Object> get props => [document, fileName];
}

final class DeletePdfOfflineStarted extends DeleteDocumentEvent {
  final DocumentModel document;

  DeletePdfOfflineStarted({
    required this.document,
  });

  @override
  List<Object> get props => [document];
}

final class DeletePdfStarted extends DeleteDocumentEvent {
  final String fileName;

  DeletePdfStarted({
    required this.fileName,
  });

  @override
  List<Object> get props => [fileName];
}
