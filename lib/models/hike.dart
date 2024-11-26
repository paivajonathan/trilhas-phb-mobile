class HikeModel {
  HikeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.length,
    required this.gpxFile,
    required this.images,
  });

  final int id;
  final String name;
  final String description;
  final String difficulty;
  final double length;
  String gpxFile;
  List<String> images;

  factory HikeModel.fromMap(Map<String, dynamic> map, String url) {
    return HikeModel(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      difficulty: map["difficulty"],
      length: double.parse(map["length"]),
      gpxFile: "$url/${map["gpx_file"]}",
      images: (map["images"] as List<dynamic>)
        .map((imageMap) => "$url/${imageMap["image"] as String}")
        .toList(),
    );
  }
}
