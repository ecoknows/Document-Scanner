import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'image_model.g.dart';

@HiveType(typeId: 1)
class ImageModel extends HiveObject {
  ImageModel({
    required this.name,
    required this.isUploaded,
    required this.bytes,
  });

  @HiveField(1)
  final String name;

  @HiveField(2)
  bool isUploaded;

  @HiveField(3)
  final Uint8List bytes;
}
