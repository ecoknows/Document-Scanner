part of 'create_image_folder_bloc.dart';

sealed class CreateImageFolderState extends Equatable {}

final class CreateImageFolderInitial extends CreateImageFolderState {
  @override
  List<Object?> get props => [];
}

final class CreateImageFolderInProgress extends CreateImageFolderState {
  @override
  List<Object?> get props => [];
}

final class CreateImageFolderSuccess extends CreateImageFolderState {
  @override
  List<Object?> get props => [];
}

final class CreateImageFolderFail extends CreateImageFolderState {
  @override
  List<Object?> get props => [];
}
