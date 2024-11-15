import 'dart:typed_data';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:document_scanner/common/classes/save_image_class.dart';
import 'package:document_scanner/features/documents/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/image_preview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
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
    return BlocBuilder<ImagePreviewBloc, ImagePreviewState>(
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
                    InkWell(
                      onTap: () async {
                        PdfDocument document = PdfDocument();

                        PdfPage page = document.pages.add();

                        final PdfImage image = PdfBitmap(
                          await SaveFile.readImageDataFromNetwork(
                            imagePreviewState.images[i],
                          ),
                        );

                        page.graphics.drawImage(
                          image,
                          Rect.fromLTWH(
                            0,
                            0,
                            page.size.width,
                            page.size.height,
                          ),
                        );

                        List<int> bytes = await document.save();

                        SaveFile.saveAndLaunchFile(bytes,
                            '${DateTime.now().millisecondsSinceEpoch}.pdf');

                        document.dispose();
                      },
                      child: const Center(
                        child: Text(
                          'Click this to download document',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        String imageStorageUrl = imagePreviewState.images[i];

                        AnimatedSnackBar.material(
                          "Image saved to gallery.",
                          type: AnimatedSnackBarType.success,
                          duration: const Duration(seconds: 5),
                          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                        ).show(context);

                        final response =
                            await http.get(Uri.parse(imageStorageUrl));

                        final Uint8List bytes = response.bodyBytes;

                        await ImageGallerySaver.saveImage(
                          bytes,
                          quality: 60,
                          name:
                              DateTime.now().microsecondsSinceEpoch.toString(),
                        );
                      },
                      child: const Center(
                        child: Text(
                          'Click this to save image to gallery',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return Container();
      },
    );
  }
}
