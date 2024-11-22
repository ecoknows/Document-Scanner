import 'dart:typed_data';

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
  final List<Uint8List> images;

  @HiveField(3)
  final Uint8List pdf;

  @override
  List<Object?> get props => [
        name,
        images,
        pdf,
      ];
}
