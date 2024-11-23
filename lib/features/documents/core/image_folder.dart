import 'package:equatable/equatable.dart';

class ImageFolder extends Equatable {
  final String id;
  final String name;

  const ImageFolder({
    required this.id,
    required this.name,
  });

  factory ImageFolder.fromJson(Map<String, dynamic> json) => ImageFolder(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
