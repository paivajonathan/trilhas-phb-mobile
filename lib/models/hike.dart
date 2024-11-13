class HikeModel {
  final int id;
  final String name;
  final String description;
  final String difficulty;
  final double length;
  String gpxFile;
  String mainImage;

  HikeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.length,
    required this.gpxFile,
    required this.mainImage,
  });

  factory HikeModel.fromMap(Map<String, dynamic> map, String url) {
    return HikeModel(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      difficulty: map["difficulty"],
      length: double.parse(map["length"]),
      gpxFile: "$url/${map["gpx_file"]}",
      mainImage: "$url/${map["image"]}",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "difficulty": difficulty,
      "length": length,
      "gpxFile": gpxFile,
      "mainImage": mainImage,
    };
  }
}