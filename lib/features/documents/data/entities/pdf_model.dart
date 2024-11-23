import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'pdf_model.g.dart';

@HiveType(typeId: 2)
class PdfModel extends Equatable {
  PdfModel({
    required this.bytes,
    required this.isUploaded,
  });

  @HiveField(1)
  final Uint8List bytes;

  @HiveField(2)
  bool isUploaded;

  @override
  List<Object?> get props => [
        bytes,
        isUploaded,
      ];
}
