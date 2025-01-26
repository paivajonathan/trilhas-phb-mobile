import "dart:async";
import "dart:convert";

import "package:flutter/foundation.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:latlong2/latlong.dart";
import "package:trilhas_phb/helpers/map.dart";
import "package:trilhas_phb/models/file.dart";
import "package:trilhas_phb/models/file_out.dart";
import "package:trilhas_phb/models/hike.dart";
import "package:http/http.dart" as http;
import "package:trilhas_phb/services/auth.dart";

import "package:http_parser/http_parser.dart";
import "package:mime/mime.dart";

class HikeService {
  final _baseUrl = dotenv.env["BASE_URL"]!;
  final _auth = AuthService();

  Future<List<HikeModel>> getAll({
    bool? hasActiveAppointments,
    bool? isActive,
  }) async {
    String token = await _auth.token;
    final queryParameters = {"ordering": "-id"};

    if (hasActiveAppointments != null) {
      queryParameters["has_active_appointments"] =
          hasActiveAppointments.toString();
    }

    if (isActive != null) {
      queryParameters["is_active"] = isActive.toString();
    }

    final uri = Uri.parse("$_baseUrl/api/v1/hikes/")
        .replace(queryParameters: queryParameters);

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          "Origin": _baseUrl,
          "Authorization": "Bearer $token",
        },
      );

      final responseStatus = response.statusCode;
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(responseData["detail"] ??
            responseData["message"] ??
            "Um erro inesperado ocorreu");
      }

      List<HikeModel> hikes = (responseData["items"] as List)
          .map((messageJson) => HikeModel.fromMap(messageJson))
          .toList();

      return hikes;
    } on http.ClientException catch (_) {
      throw Exception("Verifique a sua conexão com a internet.");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<HikeModel> getOne({
    required int hikeId,
  }) async {
    String token = await _auth.token;

    final uri = Uri.parse("$_baseUrl/api/v1/hikes/$hikeId");

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          "Origin": _baseUrl,
          "Authorization": "Bearer $token",
        },
      );

      final responseStatus = response.statusCode;
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(responseData["detail"] ??
            responseData["message"] ??
            "Um erro inesperado ocorreu");
      }

      HikeModel hike = HikeModel.fromMap(responseData);
      return hike;
    } on http.ClientException catch (_) {
      throw Exception("Verifique a sua conexão com a internet.");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<LatLng>> loadGpxPoints({
    required String gpxFile,
  }) async {
    final uri = Uri.parse(gpxFile);

    try {
      final response = await http.get(uri);

      final responseStatus = response.statusCode;
      final responseData = response.body;

      if (![200, 201].contains(responseStatus)) {
        throw Exception("Um erro inesperado ocorreu");
      }

      List<LatLng> points = await compute(parseGpx, responseData);

      return points;
    } on http.ClientException catch (_) {
      throw Exception("Verifique a sua conexão com a internet.");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<FileModel> loadGpx({
    required String gpxFile,
  }) async {
    final uri = Uri.parse(gpxFile);

    try {
      final response = await http.get(uri);

      final responseStatus = response.statusCode;
      final responseData = response.bodyBytes;

      if (![200, 201].contains(responseStatus)) {
        throw Exception("Um erro inesperado ocorreu");
      }

      return FileModel(bytes: responseData, filename: "Arquivo GPX");
    } on http.ClientException catch (_) {
      throw Exception("Verifique a sua conexão com a internet.");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<FileModel>> loadImages({
    required List<FileOutModel> images,
  }) async {
    List<FileModel> loadedImages = [];

    for (final image in images) {
      final uri = Uri.parse(image.url);

      try {
        final response =
            await http.get(uri);

        final responseStatus = response.statusCode;
        final responseData = response.bodyBytes;

        if (![200, 201].contains(responseStatus)) {
          throw Exception("Um erro inesperado ocorreu");
        }

        loadedImages.add(FileModel(bytes: responseData, filename: image.name));
      } on http.ClientException catch (_) {
        throw Exception("Verifique a sua conexão com a internet.");
      } catch (e) {
        throw Exception(e);
      }
    }

    return loadedImages;
  }

  Future<HikeModel> create({
    required String name,
    required String description,
    required String difficulty,
    required double length,
    required FileModel gpxFile,
    required List<FileModel> images,
  }) async {
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
      final imageMimeType =
          lookupMimeType(image.filename) ?? "application/octet-stream";

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
      final response =
          await request.send();
      final responseBody = await response.stream.bytesToString();

      final responseStatus = response.statusCode;
      final responseData = json.decode(responseBody) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(responseData["detail"] ??
            responseData["message"] ??
            "Um erro inesperado ocorreu");
      }

      HikeModel hike = HikeModel.fromMap(responseData);
      return hike;
    } on http.ClientException catch (_) {
      throw Exception("Verifique a sua conexão com a internet.");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<HikeModel> edit({
    required int hikeId,
    required String name,
    required String description,
    required String difficulty,
    required double length,
    required FileModel gpxFile,
    required List<FileModel> images,
  }) async {
    String token = await _auth.token;

    final url = Uri.parse("$_baseUrl/api/v1/hikes/$hikeId");

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
      final imageMimeType =
          lookupMimeType(image.filename) ?? "application/octet-stream";

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
      final response =
          await request.send();
      final responseBody = await response.stream.bytesToString();

      final responseStatus = response.statusCode;
      final responseData = json.decode(responseBody) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(responseData["detail"] ??
            responseData["message"] ??
            "Um erro inesperado ocorreu");
      }

      HikeModel hike = HikeModel.fromMap(responseData);
      return hike;
    } on http.ClientException catch (_) {
      throw Exception("Verifique a sua conexão com a internet.");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> inactivate({
    required int hikeId,
  }) async {
    try {
      String token = await _auth.token;
      final url = Uri.parse("$_baseUrl/api/v1/hikes/$hikeId");

      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Origin": _baseUrl,
          "Authorization": "Bearer $token",
        },
      );

      final responseStatus = response.statusCode;
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(responseData["detail"] ??
            responseData["message"] ??
            "Um erro inesperado ocorreu");
      }
    } on http.ClientException catch (_) {
      throw Exception("Verifique a sua conexão com a internet.");
    } catch (e) {
      throw Exception(e);
    }
  }
}
