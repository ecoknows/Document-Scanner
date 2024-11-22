import 'dart:io';
import 'dart:typed_data';

import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/common/bloc/connectivity_bloc.dart';
import 'package:document_scanner/common/classes/get_scanned_document.dart';
import 'package:document_scanner/common/classes/get_scanned_document_offline.dart';
import 'package:document_scanner/common/widgets/authenticated_appbar.dart';
import 'package:document_scanner/features/auth/core/services/firebase_auth_services.dart';
import 'package:document_scanner/features/auth/data/entities/document_model.dart';
import 'package:document_scanner/features/documents/data/image_folder.dart';
import 'package:document_scanner/features/documents/presentation/blocs/create_image_folder_bloc.dart';
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
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        selectedImages = [];
                        isSelected = !isSelected;
                      });
                    },
                    child: Text(isSelected ? "Cancel" : "Move"),
                  )
                : null,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: connectivityState.isConnectedToInternet
              ? FloatingActionButton(
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
                )
              : null,
          body: MultiBlocListener(
            listeners: [
              BlocListener<CreateImageFolderBloc, CreateImageFolderState>(
                listener: (context, state) {
                  if (state is CreateImageFolderSuccess) {
                    context
                        .read<GetScannedDocumentsBloc>()
                        .add(GetScannedDocumentsStarted());
                  }
                },
              ),
              BlocListener<MoveImageFolderBloc, MoveImageFolderState>(
                listener: (context, state) {
                  if (state is MoveImageFolderSuccess) {
                    context
                        .read<GetScannedDocumentsBloc>()
                        .add(GetScannedDocumentsStarted());
                  }
                },
              ),
            ],
            child:
                BlocBuilder<GetScannedDocumentsBloc, GetScannedDocumentsState>(
              builder: (context, getScannedDocumentsState) {
                if (getScannedDocumentsState is GetScannedDocumentsSuccess) {
                  List<GetScannedDocument> documents =
                      getScannedDocumentsState.documents;
                  List<String> images = getScannedDocumentsState.images;
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
                                    ),
                                  );
                              context.read<MoveImageFolderBloc>().add(
                                    MoveImageFolderStarted(
                                      folder: folder,
                                      documents: documents,
                                      images: selectedImages,
                                    ),
                                  );
                              setState(() {
                                selectedImages = [];
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
                                    ImagePreviewStarted(images: images),
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
                                } else {
                                  selectedImages.remove(image);
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
                  List<GetScannedDocumentOffline> documents =
                      getScannedDocumentsState.documents;

                  List<File> images = getScannedDocumentsState.images;
                  List<String> imagesPath = getScannedDocumentsState.imagesPath;

                  if (documents.isEmpty) {
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
                                  ImagePreviewStarted(images: imagesPath),
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
      },
    );
  }
}
