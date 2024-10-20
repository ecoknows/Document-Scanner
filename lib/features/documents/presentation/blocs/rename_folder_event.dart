part of 'rename_folder_bloc.dart';

sealed class RenameFolderEvent extends Equatable {}

final class RenameFolderStarted extends RenameFolderEvent {
  final String folderId;
  final String name;

  RenameFolderStarted({
    required this.folderId,
    required this.name,
  });

  @override
  List<Object> get props => [name];
}
