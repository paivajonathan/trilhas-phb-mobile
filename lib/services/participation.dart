import "dart:async";
import "dart:convert";

import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart" as http;
import "package:trilhas_phb/models/participation.dart";
import "package:trilhas_phb/services/auth.dart";

class ParticipationService {
  final _baseUrl = dotenv.env["BASE_URL"]!;
  final _auth = AuthService();

  Future<List<ParticipationModel>> getAll({
    required int appointmentId,
  }) async {
    String token = await _auth.token;
    final queryParameters = {
      "appointment_id": appointmentId.toString(),
      "is_active": true.toString(),
      "ordering": "-id",
    };

    final uri = Uri.parse("$_baseUrl/api/v1/participations/")
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
      ).timeout(const Duration(seconds: 10));

      final responseStatus = response.statusCode;
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(responseData["detail"] ??
            responseData["message"] ??
            "Um erro inesperado ocorreu");
      }

      List<ParticipationModel> participations = (responseData["items"] as List)
          .map((participation) => ParticipationModel.fromMap(participation))
          .toList();

      return participations;
    } on http.ClientException catch (_) {
      throw Exception("Verifique a sua conexão com a internet.");
    } on TimeoutException catch (_) {
      throw Exception("Tempo limite da requisição atingido.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> create({
    required int appointmentId,
  }) async {
    try {
      String token = await _auth.token;
      final url = Uri.parse("$_baseUrl/api/v1/participations/");

      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Origin": _baseUrl,
              "Authorization": "Bearer $token",
            },
            body: json.encode({
              "appointment_id": appointmentId,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final responseStatus = response.statusCode;
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(responseData["detail"] ??
            responseData["message"] ??
            "Um erro inesperado ocorreu");
      }
    } on TimeoutException catch (_) {
      throw Exception("Tempo limite da requisição atingido.");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> cancel({
    required int appointmentId,
  }) async {
    try {
      String token = await _auth.token;
      final url = Uri.parse("$_baseUrl/api/v1/participations/");

      final response = await http
          .put(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Origin": _baseUrl,
              "Authorization": "Bearer $token",
            },
            body: json.encode({
              "appointment_id": appointmentId,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final responseStatus = response.statusCode;
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(responseData["detail"] ??
            responseData["message"] ??
            "Um erro inesperado ocorreu");
      }
    } on TimeoutException catch (_) {
      throw Exception("Tempo limite da requisição atingido.");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> makeFrequency({
    required int appointmentId,
    required List<ParticipationModel> participations,
  }) async {
    try {
      String token = await _auth.token;
      final url = Uri.parse("$_baseUrl/api/v1/participations/bulk-edit/");

      final response = await http
          .put(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Origin": _baseUrl,
              "Authorization": "Bearer $token",
            },
            body: json.encode(
              {
                "appointment_id": appointmentId,
                "participations": participations.map((p) => {"id": p.id, "status": p.status}).toList(),
              },
            ),
          )
          .timeout(const Duration(seconds: 10));

      final responseStatus = response.statusCode;
      final responseData = json.decode(response.body);

      if (![200, 201].contains(responseStatus)) {
        throw Exception(responseData["detail"] ?? responseData["message"] ?? "Um erro inesperado ocorreu");
      }
    } on http.ClientException catch (_) {
      throw Exception("Verifique a sua conexão com a internet.");
    } on TimeoutException catch (_) {
      throw Exception("Tempo limite da requisição atingido.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
