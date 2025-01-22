import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:trilhas_phb/models/appointment.dart';
import "package:http/http.dart" as http;
import 'package:trilhas_phb/services/auth.dart';

class AppointmentService {
  final _baseUrl = dotenv.env["BASE_URL"]!;
  final _auth = AuthService();

  Future<List<AppointmentModel>> getAll(
    {
      bool? isActive,
      bool? isAvailable,
      bool? hasUserParticipation,
    }
  ) async {
    String token = await _auth.token;
    final queryParameters = {"ordering": "-id"};

    if (hasUserParticipation != null) queryParameters["has_user_participation"] = hasUserParticipation.toString();
    if (isActive != null) queryParameters["is_active"] = isActive.toString();
    if (isAvailable != null) queryParameters["is_available"] = isAvailable.toString();
    
    final uri = Uri.parse("$_baseUrl/api/v1/appointments/").replace(queryParameters: queryParameters);

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
        throw Exception(
          responseData["detail"] ?? responseData["message"] ?? "Um erro inesperado ocorreu"
        );
      }

      List<AppointmentModel> appointments = (responseData["items"] as List)
        .map((messageJson) => AppointmentModel.fromMap(messageJson))
        .toList();

      return appointments;
    } on TimeoutException catch (_) {
      throw Exception("Tempo limite da requisição atingido.");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<AppointmentModel> getOne(
    {
      required int appointmentId,
    }
  ) async {
    String token = await _auth.token;
    
    final uri = Uri.parse("$_baseUrl/api/v1/appointments/$appointmentId");

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
        throw Exception(
          responseData["detail"] ?? responseData["message"] ?? "Um erro inesperado ocorreu"
        );
      }

      AppointmentModel appointment = AppointmentModel.fromMap(responseData);
      return appointment;
    } on TimeoutException catch (_) {
      throw Exception("Tempo limite da requisição atingido.");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> create(
    {
      required int hikeId,
      required String date,
      required String time,
    }
  ) async {
    try {
      String token = await _auth.token;
      final url = Uri.parse("$_baseUrl/api/v1/appointments/");
    
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
            "hike_id": hikeId,
            "date": date,
            "time": time,
          },
        ),
      ).timeout(const Duration(seconds: 10));

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

  Future<void> edit(
    {
      required int appointmentId,
      required String date,
      required String time,
    }
  ) async {
    try {
      String token = await _auth.token;
      final url = Uri.parse("$_baseUrl/api/v1/appointments/$appointmentId");
    
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Origin": _baseUrl,
          "Authorization": "Bearer $token",
        },
        body: json.encode(
          {
            "date": date,
            "time": time,
          },
        ),
      ).timeout(const Duration(seconds: 10));

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

  Future<void> inactivate(
    {
      required int appointmentId,
    }
  ) async {
    try {
      String token = await _auth.token;
      final url = Uri.parse("$_baseUrl/api/v1/appointments/$appointmentId");
    
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Origin": _baseUrl,
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 10));

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
