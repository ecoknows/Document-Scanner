import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/common/widgets/authenticated_appbar.dart';
import 'package:document_scanner/features/auth/core/services/firebase_auth_services.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPreviewScreen extends StatefulWidget {
  static String name = 'PDF';
  final String? pdfName;

  const PdfPreviewScreen({
    super.key,
    required this.pdfName,
  });

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  PDFDocument? doc;
  final FirebaseAuthService _auth = FirebaseAuthService();

  Future<void> processDocument() async {
    User? user = _auth.auth.currentUser;

    if (user != null) {
      final String pdfUserPath =
          "pdf/scanned_documents/${user.uid}/${widget.pdfName}.pdf";

      final url =
          await FirebaseStorage.instance.ref(pdfUserPath).getDownloadURL();

      doc = await PDFDocument.fromURL(url);

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
        appBar: AuthenticatedAppBar(title: "${widget.pdfName}.pdf"),
        body: Center(
          child: PDFViewer(document: document),
        ),
      );
    }

    return Container();
  }
}
