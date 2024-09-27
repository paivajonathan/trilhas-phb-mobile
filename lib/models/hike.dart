class HikeModel {
  final String name;
  final String description;

  HikeModel({
    required this.name,
    required this.description,
  });

  factory HikeModel.fromMap(Map<String, dynamic> map) {
    return HikeModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
    };
  }
}