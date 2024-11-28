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
  List<String> images;

  factory HikeModel.fromMap(Map<String, dynamic> map, String url) {
    return HikeModel(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      difficulty: map["difficulty"],
      length: double.parse(map["length"]),
      isActive: map["is_active"],
      hasActiveAppointments: map["has_active_appointments"],
      gpxFile: "$url/${map["gpx_file"]}",
      images: (map["images"] as List<dynamic>)
        .map((imageMap) => "$url/${imageMap["image"] as String}")
        .toList(),
    );
  }
}
