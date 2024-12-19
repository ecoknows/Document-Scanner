import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/common/bloc/connectivity_bloc.dart';
import 'package:document_scanner/common/widgets/authenticated_appbar.dart';
import 'package:document_scanner/features/documents/presentation/blocs/delete_document_bloc.dart';
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
  bool isSelected = false;
  List<String> selectedImages = [];
  List<String> selectedImagesFilename = [];

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
    return MultiBlocListener(
      listeners: [
        BlocListener<RenameFolderBloc, RenameFolderState>(
          listener: (context, state) {
            if (state is RenameFolderSuccess) {
              context
                  .read<GetScannedDocumentsBloc>()
                  .add(GetScannedDocumentsStarted(showLoadingIndicator: true));
            }
          },
        ),
        BlocListener<DeleteDocumentBloc, DeleteDocumentState>(
          listener: (context, state) {
            if (state is DeleteDocumentSuccess) {
              String? folderId = widget.folderId;

              if (folderId != null) {
                context.read<GetFolderImagesBloc>().add(
                      GetFolderImageStarted(folderId: folderId),
                    );
              }
            }
          },
        ),
      ],
      child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (context, connectivityState) {
          if (connectivityState is! ConnectivitySuccess) {
            return Container();
          }

          return BaseScaffold(
            appBar: AuthenticatedAppBar(
              title: renameFolder ?? widget.folderName ?? FolderScreen.name,
              primaryWidget: connectivityState.isConnectedToInternet
                  ? IconButton(
                      icon: Icon(
                        isSelected ? Icons.cancel : Icons.select_all,
                      ), // Choose the desired icon
                      tooltip: isSelected ? "Cancel" : 'Select',
                      onPressed: () {
                        setState(() {
                          selectedImages = [];
                          selectedImagesFilename = [];
                          isSelected = !isSelected;
                        });
                      },
                    )
                  : null,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isSelected && selectedImages.isNotEmpty) ...[
                  FloatingActionButton(
                    onPressed: () {
                      _showDeleteDialog();
                    },
                    backgroundColor: Colors.orange,
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
                FloatingActionButton(
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
              ],
            ),
            body: BlocBuilder<GetFolderImagesBloc, GetFolderImagesState>(
              builder: (context, getFolderImageState) {
                if (getFolderImageState is GetFolderImagesSuccess) {
                  List<String> images = getFolderImageState.images;
                  List<String> imagesFilename =
                      getFolderImageState.imagesFilename;

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
                            if (isSelected == false) {
                              context.read<ImagePreviewBloc>().add(
                                    ImagePreviewStarted(
                                      images: images,
                                      imagesFilename: imagesFilename,
                                    ),
                                  );
                              context.pushNamed(
                                ImagePreviewScreen.name,
                                pathParameters: {
                                  "index": index.toString(),
                                },
                              );
                            } else {
                              setState(() {
                                if (!selectedImages.contains(image)) {
                                  selectedImages.add(image);
                                  selectedImagesFilename
                                      .add(imagesFilename[index]);
                                } else {
                                  selectedImages.remove(image);
                                  selectedImagesFilename
                                      .remove(imagesFilename[index]);
                                }
                              });
                            }
                          },
                          child: Stack(
                            children: [
                              Image.network(
                                image,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child; // Image loaded successfully
                                  }
                                  return Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.grey[
                                        200], // Placeholder background color
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.orange,
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (isSelected)
                                Positioned(
                                  left: 8,
                                  top: 8,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: selectedImages.contains(image)
                                          ? Colors.green
                                          : Colors
                                              .grey, // Change color based on selection
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors
                                            .white, // Optional border color
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  );
                }

                return Container();
              },
            ),
          );
        },
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

  Future<void> _showDeleteDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deleting Image/s'),
          content: const Text("Are you sure you want to delete item/s?"),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                context.read<DeleteDocumentBloc>().add(
                      DeleteImagesStarted(
                        fileNames: selectedImagesFilename,
                        path: "${widget.folderId}",
                      ),
                    );

                setState(() {
                  selectedImages = [];
                  selectedImagesFilename = [];
                  isSelected = false;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
