part of 'get_scanned_documents_bloc.dart';

sealed class GetScannedDocumentsEvent extends Equatable {}

final class GetScannedDocumentsStarted extends GetScannedDocumentsEvent {
  @override
  List<Object?> get props => [];
}

final class AddScannedDocumentsStarted extends GetScannedDocumentsEvent {
  final List<String> scannedDocuments;

  AddScannedDocumentsStarted({required this.scannedDocuments});

  @override
  List<Object?> get props => [scannedDocuments];
}
