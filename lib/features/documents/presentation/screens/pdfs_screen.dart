import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/common/classes/get_scanned_document.dart';
import 'package:document_scanner/common/classes/get_scanned_document_offline.dart';
import 'package:document_scanner/common/classes/save_image_class.dart';
import 'package:document_scanner/common/widgets/authenticated_appbar.dart';
import 'package:document_scanner/features/documents/data/entities/document_model.dart';
import 'package:document_scanner/features/documents/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/pdf_preview_bloc.dart';
import 'package:document_scanner/features/documents/presentation/screens/pdf_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PdfsScreen extends StatefulWidget {
  static String name = "PDF's";

  const PdfsScreen({super.key});

  @override
  State<PdfsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<PdfsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AuthenticatedAppBar(title: PdfsScreen.name),
      body: BlocBuilder<GetScannedDocumentsBloc, GetScannedDocumentsState>(
        builder: (context, getScannedDocumentsState) {
          if (getScannedDocumentsState is GetScannedDocumentsInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }

          if (getScannedDocumentsState is GetScannedDocumentsSuccess) {
            List<GetScannedDocument> documents =
                getScannedDocumentsState.documents;

            if (documents.isEmpty) {
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
                      "No pdf found",
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
                for (final document in documents)
                  InkWell(
                    onTap: () {
                      context.read<PdfPreviewBloc>().add(
                            PdfPreviewStarted(document: document),
                          );
                      context.pushNamed(
                        PdfPreviewScreen.name,
                      );
                    },
                    child: Stack(
                      children: [
                        Image.network(
                          document.image,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        const Positioned(
                          top: 5,
                          right: 5,
                          child: Icon(
                            Icons.picture_as_pdf, // Use any Material icon
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }

          if (getScannedDocumentsState is GetScannedDocumentsOfflineSuccess) {
            List<GetScannedDocumentOffline> documents =
                getScannedDocumentsState.documents;

            if (documents.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100.0,
                    ),
                    const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.black,
                      size: 100.0,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      "No pdf found",
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
                for (GetScannedDocumentOffline document in documents)
                  InkWell(
                    onTap: () {
                      context.read<PdfPreviewBloc>().add(
                            PdfPreviewOfflineStarted(document: document),
                          );
                      context.pushNamed(
                        PdfPreviewScreen.name,
                      );
                    },
                    child: Stack(
                      children: [
                        Image.file(
                          document.image,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        const Positioned(
                          top: 5,
                          right: 5,
                          child: Icon(
                            Icons.picture_as_pdf, // Use any Material icon
                            color: Colors.white,
                            size: 30,
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
    );
  }
}
