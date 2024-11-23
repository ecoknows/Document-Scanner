part of 'upload_document_to_cloud_bloc.dart';

sealed class UploadDocumentToCloudEvent extends Equatable {}

final class UploadDocumentToCloudStarted extends UploadDocumentToCloudEvent {
  UploadDocumentToCloudStarted();

  @override
  List<Object> get props => [];
}
