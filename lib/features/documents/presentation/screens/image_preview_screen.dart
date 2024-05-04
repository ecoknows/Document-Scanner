import 'package:document_scanner/features/documents/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_preview/src/image_gallery.dart';

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
          );
        }

        return Container();
      },
    );
  }
}
