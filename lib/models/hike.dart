class HikeModel {
  final int id;
  final String name;
  final String description;
  final String difficulty;
  final double length;

  HikeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.length,
  });

  factory HikeModel.fromMap(Map<String, dynamic> map) {
    return HikeModel(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      difficulty: map["difficulty"],
      length: double.parse(map["length"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "difficulty": difficulty,
      "length": length,
    };
  }
}