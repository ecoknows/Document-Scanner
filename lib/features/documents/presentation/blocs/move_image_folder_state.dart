part of 'move_image_folder_bloc.dart';

sealed class MoveImageFolderState extends Equatable {}

final class MoveImageFolderInitial extends MoveImageFolderState {
  @override
  List<Object> get props => [];
}

final class MoveImageFolderSuccess extends MoveImageFolderState {
  @override
  List<Object> get props => [];
}

final class MoveImageFolderInProgress extends MoveImageFolderState {
  @override
  List<Object> get props => [];
}

final class MoveImageFolderFail extends MoveImageFolderState {
  @override
  List<Object> get props => [];
}
