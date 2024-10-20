part of 'create_image_folder_bloc.dart';

sealed class CreateImageFolderEvent extends Equatable {}

final class CreateImageFolderStarted extends CreateImageFolderEvent {
  @override
  List<Object?> get props => [];
}
