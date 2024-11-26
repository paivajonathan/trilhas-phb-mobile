import "dart:async";
import "dart:convert";

import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:trilhas_phb/models/file.dart";
import "package:trilhas_phb/models/hike.dart";
import "package:http/http.dart" as http;
import "package:trilhas_phb/services/auth.dart";

import "package:http_parser/http_parser.dart";
import "package:mime/mime.dart";

class HikeService {
  final _baseUrl = dotenv.env["BASE_URL"]!;
  final _auth = AuthService();

  Future<List<HikeModel>> getAll(
    {
      bool? hasActiveAppointments,
    }
  ) async {
    String token = await _auth.token;
  
    final queryParameters = {
      "ordering": "-id",
    };

    if (hasActiveAppointments != null) {
      queryParameters["has_active_appointments"] = hasActiveAppointments.toString();
    }
    
    final uri = Uri.parse("$_baseUrl/api/v1/hikes/").replace(
      queryParameters: queryParameters
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          "Origin": _baseUrl,
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 5));

      final responseStatus = response.statusCode;
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(
          responseData["detail"] ?? responseData["message"] ?? "Um erro inesperado ocorreu"
        );
      }

      List<HikeModel> hikes = (responseData["items"] as List)
        .map((messageJson) => HikeModel.fromMap(messageJson, _baseUrl))
        .toList();

      return hikes;
    } on TimeoutException catch (_) {
      throw Exception("Tempo limite da requisição atingido.");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<HikeModel> create(
    {
      required String name,
      required String description,
      required String difficulty,
      required double length,
      required FileModel gpxFile,
      required List<FileModel> images,
    }
  ) async {
    String token = await _auth.token;

    final url = Uri.parse("$_baseUrl/api/v1/hikes/");

    final request = http.MultipartRequest("POST", url)
      ..headers.addAll({
        "Accept": "application/json",
        "Origin": _baseUrl,
        "Authorization": "Bearer $token",
      })
      ..files.add(http.MultipartFile.fromBytes(
        "gpx_file",
        gpxFile.bytes,
        filename: gpxFile.filename,
      ));

    for (var image in images) {
      final imageMimeType = lookupMimeType(image.filename) ?? "application/octet-stream";

      request.files.add(http.MultipartFile.fromBytes(
        "images",
        image.bytes,
        filename: image.filename,
        contentType: MediaType.parse(imageMimeType),
      ));
    }

    request.fields["payload"] = jsonEncode({
      "name": name,
      "description": description,
      "difficulty": difficulty,
      "length": length,
    });

    try {
      final response = await request.send().timeout(const Duration(seconds: 5));
      final responseBody = await response.stream.bytesToString();

      final responseStatus = response.statusCode;
      final responseData = json.decode(responseBody) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(
          responseData["detail"] ?? responseData["message"] ?? "Um erro inesperado ocorreu"
        );
      }

      HikeModel hike = HikeModel.fromMap(responseData, _baseUrl);
      return hike;
    } on TimeoutException catch (_) {
      throw Exception("Tempo limite da requisição atingido.");
    } catch (e) {
      throw Exception(e);
    }
  }
}
