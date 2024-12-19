import 'dart:io';
import 'dart:typed_data';

import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/common/bloc/connectivity_bloc.dart';
import 'package:document_scanner/common/classes/get_scanned_document.dart';
import 'package:document_scanner/common/classes/get_scanned_document_offline.dart';
import 'package:document_scanner/common/widgets/authenticated_appbar.dart';
import 'package:document_scanner/features/auth/core/services/firebase_auth_services.dart';
import 'package:document_scanner/features/documents/data/entities/document_model.dart';
import 'package:document_scanner/features/documents/core/image_folder.dart';
import 'package:document_scanner/features/documents/presentation/blocs/create_image_folder_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/delete_document_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/image_preview_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/move_image_folder_bloc.dart';
import 'package:document_scanner/features/documents/presentation/screens/folder_screen.dart';
import 'package:document_scanner/features/documents/presentation/screens/image_preview_screen.dart';
import 'package:document_scanner/features/documents/presentation/screens/pdf_preview_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImagesScreen extends StatefulWidget {
  static String name = 'Images';

  const ImagesScreen({super.key});

  @override
  State<ImagesScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<ImagesScreen> {
  bool isSelected = false;
  List<String> selectedImages = [];
  List<String> selectedImagesFilename = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (_, connectivityState) {
        if (connectivityState is! ConnectivitySuccess) {
          return Container();
        }

        return BaseScaffold(
          appBar: AuthenticatedAppBar(
            title: ImagesScreen.name,
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
          floatingActionButton: connectivityState.isConnectedToInternet
              ? Row(
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
                        context
                            .read<CreateImageFolderBloc>()
                            .add(CreateImageFolderStarted());
                      },
                      backgroundColor: Colors.orange,
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.drive_folder_upload_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              : null,
          body: MultiBlocListener(
            listeners: [
              BlocListener<DeleteDocumentBloc, DeleteDocumentState>(
                listener: (context, state) {
                  if (state is DeleteDocumentSuccess) {
                    context.read<GetScannedDocumentsBloc>().add(
                          GetScannedDocumentsStarted(
                            showLoadingIndicator: true,
                          ),
                        );
                  }
                },
              ),
              BlocListener<CreateImageFolderBloc, CreateImageFolderState>(
                listener: (context, state) {
                  if (state is CreateImageFolderSuccess) {
                    context.read<GetScannedDocumentsBloc>().add(
                          GetScannedDocumentsStarted(
                            showLoadingIndicator: true,
                          ),
                        );
                  }
                },
              ),
              BlocListener<MoveImageFolderBloc, MoveImageFolderState>(
                listener: (context, state) {
                  if (state is MoveImageFolderSuccess) {
                    context.read<GetScannedDocumentsBloc>().add(
                          GetScannedDocumentsStarted(
                            showLoadingIndicator: false,
                          ),
                        );
                  }
                },
              ),
            ],
            child:
                BlocBuilder<GetScannedDocumentsBloc, GetScannedDocumentsState>(
              builder: (context, getScannedDocumentsState) {
                if (getScannedDocumentsState is GetScannedDocumentsSuccess) {
                  List<String> images = getScannedDocumentsState.images;
                  List<String> imagesFilename =
                      getScannedDocumentsState.imagesFilename;
                  List<ImageFolder> folders =
                      getScannedDocumentsState.imageFolders;

                  if (images.isEmpty && folders.isEmpty) {
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
                      for (final folder in folders)
                        InkWell(
                          onTap: () {
                            if (isSelected && selectedImages.isNotEmpty) {
                              context.read<GetScannedDocumentsBloc>().add(
                                    RemoveImagesStarted(
                                      images: selectedImages,
                                      imagesFilename: selectedImagesFilename,
                                    ),
                                  );
                              context.read<MoveImageFolderBloc>().add(
                                    MoveImageFolderStarted(
                                      folder: folder,
                                      images: selectedImages,
                                      imagesFilename: selectedImagesFilename,
                                    ),
                                  );
                              setState(() {
                                selectedImages = [];
                                selectedImagesFilename = [];
                                isSelected = !isSelected;
                              });
                            } else {
                              context.pushNamed(
                                FolderScreen.name,
                                pathParameters: {
                                  "folderId": folder.id,
                                  "folderName": folder.name,
                                },
                              );
                            }
                          },
                          child: Column(
                            children: [
                              const Icon(
                                Icons.drive_folder_upload_sharp,
                                color: Colors.black,
                                size: 60,
                              ),
                              Text(
                                folder.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                        ),
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

                if (getScannedDocumentsState
                    is GetScannedDocumentsOfflineSuccess) {
                  List<File> images = getScannedDocumentsState.images;
                  List<GetScannedDocumentOffline> documents =
                      getScannedDocumentsState.documents;
                  List<String> imagesPath = getScannedDocumentsState.imagesPath;

                  if (images.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100.0,
                          ),
                          const Icon(
                            Icons.image,
                            color: Colors.black,
                            size: 100.0,
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            "No image found",
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
                                  ImagePreviewOfflineStarted(
                                    images: imagesPath,
                                    documents: documents,
                                  ),
                                );
                            context.pushNamed(
                              ImagePreviewScreen.name,
                              pathParameters: {
                                "index": index.toString(),
                              },
                            );
                          },
                          child: Stack(
                            children: [
                              Image.file(
                                image,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
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
                        "No images found",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
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
