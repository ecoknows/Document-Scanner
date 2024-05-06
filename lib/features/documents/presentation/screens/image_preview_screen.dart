import 'package:document_scanner/common/classes/save_image_class.dart';
import 'package:document_scanner/features/documents/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_preview/src/image_gallery.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

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
  @override
  Widget build(BuildContext context) {
    String? index = widget.index;
    return BlocBuilder<GetScannedDocumentsBloc, GetScannedDocumentsState>(
      builder: (context, getScannedDocumentsState) {
        if (getScannedDocumentsState is GetScannedDocumentsSuccess &&
            index != null) {
          return ImageGalleryPage(
              imageUrls: getScannedDocumentsState.documents,
              heroTags: getScannedDocumentsState.documents,
              initialIndex: int.parse(index),
              onPageChanged: (i, widget) async {
                return Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: InkWell(
                    onTap: () async {
                      PdfDocument document = PdfDocument();

                      PdfPage page = document.pages.add();

                      final PdfImage image = PdfBitmap(
                        await SaveFile.readImageDataFromNetwork(
                          getScannedDocumentsState.documents[i],
                        ),
                      );

                      page.graphics.drawImage(
                          image,
                          Rect.fromLTWH(
                              0, 0, page.size.width, page.size.height));

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
                );
              });
        }

        return Container();
      },
    );
  }
}
