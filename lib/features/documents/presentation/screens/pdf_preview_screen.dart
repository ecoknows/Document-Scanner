import 'dart:io';

import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/common/widgets/authenticated_appbar.dart';
import 'package:document_scanner/features/auth/core/services/firebase_auth_services.dart';
import 'package:document_scanner/features/documents/core/date_helper.dart';
import 'package:document_scanner/features/documents/core/string_helper.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPreviewScreen extends StatefulWidget {
  static String name = 'PDF';
  final String pdfName;
  final String pdfPath;
  final String isOffline;

  const PdfPreviewScreen({
    super.key,
    required this.pdfName,
    required this.pdfPath,
    required this.isOffline,
  });

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  PDFDocument? doc;
  final FirebaseAuthService _auth = FirebaseAuthService();

  Future<void> processDocument() async {
    User? user = _auth.auth.currentUser;
    String? path = widget.pdfPath;

    if (user != null && widget.isOffline == "no") {
      final String pdfUserPath =
          "pdf/scanned_documents/${user.uid}/${widget.pdfName}.pdf";

      final url =
          await FirebaseStorage.instance.ref(pdfUserPath).getDownloadURL();

      doc = await PDFDocument.fromURL(url);

      setState(() {});
    } else if (widget.isOffline == "yes" && path != "null") {
      doc = await PDFDocument.fromFile(
        File(
          path,
        ),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    processDocument();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PDFDocument? document = doc;

    if (document != null) {
      return BaseScaffold(
        appBar: AuthenticatedAppBar(
          title: "",
          customizeAppBar: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("PDF Viewer"),
              Text(
                DateHelper.timestampToReadableDate(
                  widget.pdfName,
                ),
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        body: Center(
          child: PDFViewer(document: document),
        ),
      );
    }

    return Container();
  }
}
