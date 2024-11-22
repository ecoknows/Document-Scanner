// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:document_scanner/features/auth/data/entities/document_model.dart';

class GetScannedDocumentOffline {
  DocumentModel document;
  String name;
  File image;
  File pdf;

  GetScannedDocumentOffline({
    required this.document,
    required this.name,
    required this.image,
    required this.pdf,
  });
}
