import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/models/hike.dart';
import "package:http/http.dart" as http;
import 'package:trilhas_phb/services/auth.dart';

class AppointmentService {
  final _baseUrl = dotenv.env["BASE_URL"]!;
  final _auth = AuthService();

  Future<List<AppointmentModel>> getAll(
    {
      bool? isPresent,
    }
  ) async {
    String token = await _auth.token;
  
    final queryParameters = {
      "ordering": "-id",
    };

    if (isPresent != null) {
      queryParameters["is_present"] = isPresent.toString();
    }
    
    final uri = Uri.parse("$_baseUrl/api/v1/appointments/").replace(
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

      List<AppointmentModel> appointments = (responseData["items"] as List)
        .map((messageJson) => AppointmentModel.fromMap(messageJson, _baseUrl))
        .toList();

      return appointments;
    } on TimeoutException catch (_) {
      throw Exception("Tempo limite da requisição atingido.");
    } catch (e) {
      throw Exception(e);
    }
  }
}
