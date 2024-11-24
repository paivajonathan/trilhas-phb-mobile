import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:trilhas_phb/models/hike.dart';
import "package:http/http.dart" as http;
import 'package:trilhas_phb/services/auth.dart';

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
      queryParameters["has_active_appointmentes"] = hasActiveAppointments.toString();
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
}
