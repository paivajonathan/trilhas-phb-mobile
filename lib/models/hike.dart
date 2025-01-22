import 'package:trilhas_phb/models/file_out.dart';

class HikeModel {
  HikeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.length,
    required this.isActive,
    required this.hasActiveAppointments,
    required this.gpxFile,
    required this.images,
  });

  final int id;
  final String name;
  final String description;
  final String difficulty;
  final double length;
  final bool isActive;
  final bool hasActiveAppointments;
  String gpxFile;
  List<FileOutModel> images;

  factory HikeModel.fromMap(Map<String, dynamic> map) {
    return HikeModel(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      difficulty: map["difficulty"],
      length: double.parse(map["length"]),
      isActive: map["is_active"],
      hasActiveAppointments: map["has_active_appointments"],
      gpxFile: map["gpx_file"],
      images: (map["images"] as List<dynamic>)
          .map((imageMap) => FileOutModel.fromMap(imageMap))
          .toList(),
    );
  }

  String get readableDifficulty {
    return switch (difficulty) {
      "H" => "DIFÍCIL",
      "M" => "MÉDIO",
      "E" => "FÁCIL",
      _ => "INVÁLIDO",
    };
  }

  int get difficultyColor {
    return switch(difficulty) {
      "H" => 0xFFFF0000,
      "M" => 0xFFFFDE21,
      "E" => 0xFF00BF63,
      _ => 0xFF000000,
    };
  }
}
