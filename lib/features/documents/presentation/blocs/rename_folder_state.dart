part of 'rename_folder_bloc.dart';

sealed class RenameFolderState extends Equatable {}

final class RenameFolderInitial extends RenameFolderState {
  @override
  List<Object> get props => [];
}

final class RenameFolderInProgress extends RenameFolderState {
  @override
  List<Object> get props => [];
}

final class RenameFolderSuccess extends RenameFolderState {
  @override
  List<Object> get props => [];
}

final class RenameFolderFail extends RenameFolderState {
  @override
  List<Object> get props => [];
}
