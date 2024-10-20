import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/common/widgets/authenticated_appbar.dart';
import 'package:document_scanner/features/documents/presentation/blocs/get_folder_images_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/image_preview_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/rename_folder_bloc.dart';
import 'package:document_scanner/features/documents/presentation/screens/image_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FolderScreen extends StatefulWidget {
  static String name = 'Folder';
  final String? folderId;
  final String? folderName;

  const FolderScreen({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  String? renameFolder;

  @override
  void initState() {
    super.initState();

    String? folderId = widget.folderId;

    if (folderId != null) {
      context.read<GetFolderImagesBloc>().add(
            GetFolderImageStarted(folderId: folderId),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RenameFolderBloc, RenameFolderState>(
      listener: (context, state) {
        if (state is RenameFolderSuccess) {
          context
              .read<GetScannedDocumentsBloc>()
              .add(GetScannedDocumentsStarted());
        }
      },
      child: BaseScaffold(
        appBar: AuthenticatedAppBar(
          title: renameFolder ?? widget.folderName ?? FolderScreen.name,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _showRenameDialog();
          },
          backgroundColor: Colors.orange,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.drive_file_rename_outline_rounded,
            color: Colors.black,
          ),
        ),
        body: BlocBuilder<GetFolderImagesBloc, GetFolderImagesState>(
          builder: (context, getFolderImageState) {
            if (getFolderImageState is GetFolderImagesSuccess) {
              List<String> images = getFolderImageState.images;

              if (images.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100.0,
                      ),
                      const Icon(
                        Icons.document_scanner,
                        color: Colors.black,
                        size: 100.0,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "No documents found",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                );
              }

              return GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                crossAxisCount: 4,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: [
                  for (final (index, image) in images.indexed)
                    InkWell(
                      onTap: () {
                        context.read<ImagePreviewBloc>().add(
                              ImagePreviewStarted(images: images),
                            );
                        context.pushNamed(
                          ImagePreviewScreen.name,
                          pathParameters: {
                            "index": index.toString(),
                          },
                        );
                      },
                      child: Image.network(
                        image,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              );
            }

            return Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 100.0,
                  ),
                  const Icon(
                    Icons.document_scanner,
                    color: Colors.black,
                    size: 100.0,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "No documents found",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Method to show the rename dialog
  Future<void> _showRenameDialog() async {
    TextEditingController nameController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rename Folder'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Enter new folder name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                String? id = widget.folderId;

                if (id != null) {
                  context.read<RenameFolderBloc>().add(
                        RenameFolderStarted(
                          folderId: id,
                          name: nameController.text,
                        ),
                      );
                  setState(() {
                    renameFolder = nameController.text;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
