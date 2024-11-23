import 'dart:typed_data';

import 'package:document_scanner/features/documents/data/entities/image_model.dart';
import 'package:document_scanner/features/documents/data/entities/pdf_model.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'document_model.g.dart';

@HiveType(typeId: 0)
class DocumentModel extends Equatable {
  const DocumentModel({
    required this.name,
    required this.images,
    required this.pdf,
  });

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<ImageModel> images;

  @HiveField(3)
  final PdfModel pdf;

  DocumentModel copyWith({
    String? name,
    List<ImageModel>? images,
    PdfModel? pdf,
  }) {
    return DocumentModel(
      name: name ?? this.name,
      images: images ?? this.images,
      pdf: pdf ?? this.pdf,
    );
  }

  @override
  List<Object?> get props => [
        name,
        images,
        pdf,
      ];
}
