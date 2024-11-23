part of 'delete_document_bloc.dart';

sealed class DeleteDocumentState extends Equatable {}

final class DeleteDocumentInitial extends DeleteDocumentState {
  @override
  List<Object> get props => [];
}

final class DeleteDocumentInProgress extends DeleteDocumentState {
  @override
  List<Object> get props => [];
}

final class DeleteDocumentSuccess extends DeleteDocumentState {
  final bool isOffline;

  DeleteDocumentSuccess({required this.isOffline});

  @override
  List<Object> get props => [];
}

final class DeleteDocumentOfflineSuccess extends DeleteDocumentState {
  @override
  List<Object> get props => [];
}

final class DeleteDocumentFail extends DeleteDocumentState {
  @override
  List<Object> get props => [];
}
