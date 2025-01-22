import 'dart:typed_data';

class FileModel {
  final Uint8List bytes;
  final String filename;

  FileModel({
    required this.bytes,
    required this.filename,
  });
}
