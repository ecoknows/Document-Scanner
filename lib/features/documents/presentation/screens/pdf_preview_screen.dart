import 'dart:io';

import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/common/classes/get_scanned_document.dart';
import 'package:document_scanner/common/classes/get_scanned_document_offline.dart';
import 'package:document_scanner/common/widgets/authenticated_appbar.dart';
import 'package:document_scanner/features/documents/core/date_helper.dart';
import 'package:document_scanner/features/documents/core/image_helper.dart';
import 'package:document_scanner/features/documents/core/pdf_helper.dart';
import 'package:document_scanner/features/documents/presentation/blocs/delete_document_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/pdf_preview_bloc.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class PdfPreviewScreen extends StatefulWidget {
  static String name = 'PDF';

  const PdfPreviewScreen({
    super.key,
  });

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteDocumentBloc, DeleteDocumentState>(
      listener: (_, deleteDocumentState) {
        if (deleteDocumentState is DeleteDocumentSuccess) {
          context.read<GetScannedDocumentsBloc>().add(
              GetScannedDocumentsOfflineStarted(showLoadingIndicator: true));

          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<PdfPreviewBloc, PdfPreviewState>(
        builder: (context, pdfPreviewState) {
          if (pdfPreviewState is PdfPreviewSuccess) {
            return BaseScaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.startFloat,
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: Row(
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        _showDeleteDialog(pdfPreviewState.document.name);
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
                    FloatingActionButton(
                      onPressed: () async {
                        File pdf = await PdfHelper.pdfUrlToFile(
                          pdfPreviewState.document.pdf,
                          pdfPreviewState.document.name,
                        );

                        await Share.shareXFiles(
                          [XFile(pdf.path)],
                          text: pdfPreviewState.document.name,
                        );
                      },
                      backgroundColor: Colors.orange,
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.share,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              appBar: AuthenticatedAppBar(
                title: "",
                customizeAppBar: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("PDF Viewer"),
                    Text(
                      DateHelper.timestampToReadableDate(
                        pdfPreviewState.document.name,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              body: Center(
                child: PDFViewer(document: pdfPreviewState.pdfDocument),
              ),
            );
          }
          if (pdfPreviewState is PdfPreviewOfflineSuccess) {
            return BaseScaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.startFloat,
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: Row(
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        _showDeleteDialog(pdfPreviewState.document.name);
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
                    FloatingActionButton(
                      onPressed: () async {
                        await Share.shareXFiles(
                          [XFile(pdfPreviewState.document.pdf.path)],
                          text: pdfPreviewState.document.name,
                        );
                      },
                      backgroundColor: Colors.orange,
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.share,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              appBar: AuthenticatedAppBar(
                title: "",
                customizeAppBar: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("PDF Viewer"),
                    Text(
                      DateHelper.timestampToReadableDate(
                        pdfPreviewState.document.name,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              body: Center(
                child: PDFViewer(document: pdfPreviewState.pdfDocument),
              ),
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
                      DeletePdfStarted(
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
                      DeletePdfOfflineStarted(
                        document: getScannedDocumentOffline.document,
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
