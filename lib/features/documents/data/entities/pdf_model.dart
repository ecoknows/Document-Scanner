import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'pdf_model.g.dart';

@HiveType(typeId: 2)
class PdfModel extends HiveObject {
  PdfModel({
    required this.name,
    required this.isUploaded,
    required this.imageBytes,
    required this.bytes,
  });

  @HiveField(1)
  String name;

  @HiveField(2)
  bool isUploaded;

  @HiveField(3)
  final Uint8List imageBytes;

  @HiveField(4)
  final Uint8List bytes;
}
