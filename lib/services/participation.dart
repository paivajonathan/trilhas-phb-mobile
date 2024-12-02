import "dart:async";
import "dart:convert";

import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart" as http;
import "package:trilhas_phb/services/auth.dart";

class ParticipationService {
  final _baseUrl = dotenv.env["BASE_URL"]!;
  final _auth = AuthService();

  Future<void> create(
    {
      required int appointmentId,
    }
  ) async {
    try {
      String token = await _auth.token;
      final url = Uri.parse("$_baseUrl/api/v1/participations/");
    
      final response = await http.post(
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
          }
        ),
      ).timeout(const Duration(seconds: 5));

      final responseStatus = response.statusCode;
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(
          responseData["detail"] ?? responseData["message"] ?? "Um erro inesperado ocorreu"
        );
      }
    } on TimeoutException catch (_) {
      throw Exception("Tempo limite da requisição atingido.");
    } catch (e) {
      throw Exception(e);
    }    
  }
}
