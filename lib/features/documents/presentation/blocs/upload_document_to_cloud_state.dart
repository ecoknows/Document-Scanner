part of 'upload_document_to_cloud_bloc.dart';

sealed class UploadDocumentToCloudState extends Equatable {}

final class UploadDocumentToCloudInitial extends UploadDocumentToCloudState {
  UploadDocumentToCloudInitial();

  @override
  List<Object> get props => [];
}

final class UploadDocumentToCloudInProgress extends UploadDocumentToCloudState {
  @override
  List<Object> get props => [];
}

final class UploadDocumentToCloudSuccess extends UploadDocumentToCloudState {
  UploadDocumentToCloudSuccess();

  @override
  List<Object> get props => [];
}

final class UploadDocumentToCloudFail extends UploadDocumentToCloudState {
  @override
  List<Object> get props => [];
}
