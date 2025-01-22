class FileOutModel {
  FileOutModel({
    required this.url,
    required this.name,
    required this.size,
  });

  final String url;
  final String name;
  final int size;

  factory FileOutModel.fromMap(Map<String, dynamic> map) {
    return FileOutModel(
      url: map["image"],
      size: map["size"],
      name: map["name"],
    );
  }
}