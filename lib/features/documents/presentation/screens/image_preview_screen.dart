import 'dart:io';
import 'dart:typed_data';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:document_scanner/common/bloc/connectivity_bloc.dart';
import 'package:document_scanner/common/classes/get_scanned_document.dart';
import 'package:document_scanner/common/classes/get_scanned_document_offline.dart';
import 'package:document_scanner/common/classes/save_image_class.dart';
import 'package:document_scanner/features/documents/core/date_helper.dart';
import 'package:document_scanner/features/documents/core/image_helper.dart';
import 'package:document_scanner/features/documents/core/string_helper.dart';
import 'package:document_scanner/features/documents/data/entities/document_model.dart';
import 'package:document_scanner/features/documents/presentation/blocs/delete_document_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/image_preview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:image_preview/src/image_gallery.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class ImagePreviewScreen extends StatefulWidget {
  static String name = 'Image Preview Screen';
  final String? index;
  const ImagePreviewScreen({
    super.key,
    required this.index,
  });

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  void savedSuccess() {}

  @override
  Widget build(BuildContext context) {
    String? index = widget.index;
    return BlocListener<DeleteDocumentBloc, DeleteDocumentState>(
      listener: (_, state) {
        if (state is DeleteDocumentSuccess) {
          if (state.isOffline) {
            context.read<GetScannedDocumentsBloc>().add(
                GetScannedDocumentsOfflineStarted(showLoadingIndicator: true));
          }
          if (state.isOffline == false) {
            context
                .read<GetScannedDocumentsBloc>()
                .add(GetScannedDocumentsStarted(showLoadingIndicator: true));
          }

          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<ImagePreviewBloc, ImagePreviewState>(
        builder: (_, imagePreviewState) {
          if (imagePreviewState is ImagePreviewSuccess && index != null) {
            return ImageGalleryPage(
              imageUrls: imagePreviewState.images,
              heroTags: imagePreviewState.images,
              initialIndex: int.parse(index),
              onPageChanged: (i, widget) async {
                return Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Text(
                        DateHelper.timestampToReadableDate(
                          StringHelper.extractFileName(
                            imagePreviewState.imagesFilename[i],
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              ConnectivityState connectivityState =
                                  context.read<ConnectivityBloc>().state;

                              if (connectivityState is ConnectivitySuccess) {
                                PdfDocument document = PdfDocument();
                                PdfPage page = document.pages.add();

                                final PdfImage image = PdfBitmap(
                                  connectivityState.isConnectedToInternet
                                      ? await SaveFile.readImageDataFromNetwork(
                                          imagePreviewState.images[i],
                                        )
                                      : await File(imagePreviewState.images[i])
                                          .readAsBytes(),
                                );

                                page.graphics.drawImage(
                                  image,
                                  Rect.fromLTWH(
                                      0, 0, page.size.width, page.size.height),
                                );

                                List<int> bytes = await document.save();
                                SaveFile.saveAndLaunchFile(bytes,
                                    '${DateTime.now().millisecondsSinceEpoch}.pdf');

                                document.dispose();
                              }
                            },
                            icon: const Icon(
                              Icons.picture_as_pdf,
                              size: 14,
                            ),
                            label: const Text(
                              "Save PDF",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              ConnectivityState connectivityState =
                                  context.read<ConnectivityBloc>().state;

                              if (connectivityState is ConnectivitySuccess) {
                                String imagePath = connectivityState
                                        .isConnectedToInternet
                                    ? imagePreviewState.images[i]
                                    : await File(imagePreviewState.images[i])
                                        .path;

                                final Uint8List bytes =
                                    connectivityState.isConnectedToInternet
                                        ? (await http.get(Uri.parse(imagePath)))
                                            .bodyBytes
                                        : await File(imagePath).readAsBytes();

                                await ImageGallerySaver.saveImage(
                                  bytes,
                                  quality: 60,
                                  name: DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString(),
                                );

                                AnimatedSnackBar.material(
                                  "Image saved to gallery.",
                                  type: AnimatedSnackBarType.success,
                                  duration: const Duration(seconds: 5),
                                  mobileSnackBarPosition:
                                      MobileSnackBarPosition.bottom,
                                ).show(context);
                              }
                            },
                            icon: const Icon(
                              Icons.photo,
                              size: 14,
                            ),
                            label: const Text(
                              "Save Image",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.delete), // The icon to display
                            onPressed: () {
                              _showDeleteDialog(
                                imagePreviewState.imagesFilename[i],
                              );
                            },
                            iconSize: 24.0, // Icon size
                            splashRadius: 30.0, // Adjust splash size
                            style: IconButton.styleFrom(
                              // Optional for material 3
                              backgroundColor: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.share), // The icon to display
                            onPressed: () async {
                              File image = await ImageHelper.imageUrlToFile(
                                imagePreviewState.images[i],
                                imagePreviewState.imagesFilename[i],
                              );

                              await Share.shareXFiles(
                                [XFile(image.path)],
                                text: imagePreviewState.imagesFilename[i],
                              );
                            },
                            iconSize: 24.0, // Icon size
                            splashRadius: 30.0, // Adjust splash size
                            style: IconButton.styleFrom(
                              // Optional for material 3
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }

          if (imagePreviewState is ImagePreviewOfflineSuccess &&
              index != null) {
            return ImageGalleryPage(
              imageUrls: imagePreviewState.images,
              heroTags: imagePreviewState.images,
              initialIndex: int.parse(index),
              onPageChanged: (i, widget) async {
                return Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Text(
                        DateHelper.timestampToReadableDate(
                          StringHelper.getFileName(
                            imagePreviewState.images[i],
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              ConnectivityState connectivityState =
                                  context.read<ConnectivityBloc>().state;

                              if (connectivityState is ConnectivitySuccess) {
                                PdfDocument document = PdfDocument();
                                PdfPage page = document.pages.add();

                                final PdfImage image = PdfBitmap(
                                  connectivityState.isConnectedToInternet
                                      ? await SaveFile.readImageDataFromNetwork(
                                          imagePreviewState.images[i],
                                        )
                                      : await File(imagePreviewState.images[i])
                                          .readAsBytes(),
                                );

                                page.graphics.drawImage(
                                  image,
                                  Rect.fromLTWH(
                                      0, 0, page.size.width, page.size.height),
                                );

                                List<int> bytes = await document.save();
                                SaveFile.saveAndLaunchFile(bytes,
                                    '${DateTime.now().millisecondsSinceEpoch}.pdf');

                                document.dispose();
                              }
                            },
                            icon: const Icon(
                              Icons.picture_as_pdf,
                              size: 14,
                            ),
                            label: const Text(
                              "Save PDF",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              ConnectivityState connectivityState =
                                  context.read<ConnectivityBloc>().state;

                              if (connectivityState is ConnectivitySuccess) {
                                String imagePath = connectivityState
                                        .isConnectedToInternet
                                    ? imagePreviewState.images[i]
                                    : await File(imagePreviewState.images[i])
                                        .path;

                                final Uint8List bytes =
                                    connectivityState.isConnectedToInternet
                                        ? (await http.get(Uri.parse(imagePath)))
                                            .bodyBytes
                                        : await File(imagePath).readAsBytes();

                                await ImageGallerySaver.saveImage(
                                  bytes,
                                  quality: 60,
                                  name: DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString(),
                                );

                                AnimatedSnackBar.material(
                                  "Image saved to gallery.",
                                  type: AnimatedSnackBarType.success,
                                  duration: const Duration(seconds: 5),
                                  mobileSnackBarPosition:
                                      MobileSnackBarPosition.bottom,
                                ).show(context);
                              }
                            },
                            icon: const Icon(
                              Icons.photo,
                              size: 14,
                            ),
                            label: const Text(
                              "Save Image",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.delete), // The icon to display
                            onPressed: () {
                              String name = StringHelper.getFileName(
                                imagePreviewState.images[i],
                              );

                              GetScannedDocumentOffline documentModel =
                                  imagePreviewState.documents.firstWhere(
                                (element) => element.name == name,
                              );

                              _showOfflineDeleteDialog(
                                StringHelper.getFileFullName(
                                  imagePreviewState.images[i],
                                ),
                                documentModel,
                              );
                            },
                            iconSize: 24.0, // Icon size
                            splashRadius: 30.0, // Adjust splash size
                            style: IconButton.styleFrom(
                              // Optional for material 3
                              backgroundColor: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.share), // The icon to display
                            onPressed: () async {
                              String name = StringHelper.getFileName(
                                imagePreviewState.images[i],
                              );

                              GetScannedDocumentOffline documentModel =
                                  imagePreviewState.documents.firstWhere(
                                (element) => element.name == name,
                              );

                              await Share.shareXFiles(
                                [XFile(documentModel.image.path)],
                                text: documentModel.name,
                              );
                            },
                            iconSize: 24.0, // Icon size
                            splashRadius: 30.0, // Adjust splash size
                            style: IconButton.styleFrom(
                              // Optional for material 3
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  Future<void> _showDeleteDialog(
    String fileName,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deleting Image'),
          content: const Text("Are you sure you want to delete this?"),
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
                      DeleteImageStarted(
                        fileName: fileName,
                      ),
                    );

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showOfflineDeleteDialog(
    String fileName,
    GetScannedDocumentOffline getScannedDocumentOffline,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deleting Image'),
          content: const Text("Are you sure you want to delete this?"),
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
                      DeleteImageOfflineStarted(
                        document: getScannedDocumentOffline.document,
                        fileName: fileName,
                      ),
                    );

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
