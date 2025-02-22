import 'dart:convert';
import "dart:async";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:trilhas_phb/models/user_data.dart';
import 'package:trilhas_phb/services/auth.dart';

class UserService {
  final String _baseUrl = dotenv.env["BASE_URL"]!;
  final _auth = AuthService();

  Future<List<UserProfileModel>> fetchUsers({
    bool? isAccepted,
    bool orderByName = true,
    bool orderAsc = true,
  }) async {
    String token = await _auth.token;

    final params = {
      "is_active": true.toString(),
      "user_type": "H",
    };

    if (isAccepted != null) params["is_accepted"] = isAccepted.toString();

    if (orderByName) {
      params["ordering"] =
          "${orderAsc ? "" : "-"}profile_customuser_user__full_name,profile_customuser_user__stars";
    } else {
      params["ordering"] =
          "${orderAsc ? "" : "-"}profile_customuser_user__stars,profile_customuser_user__full_name";
    }

    final uri =
        Uri.parse("$_baseUrl/api/v1/users/").replace(queryParameters: params);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Origin": _baseUrl,
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode != 200) {
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Erro ao buscar usuários';
        throw Exception(errorMessage);
      }

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (data["items"] != null) {
        return (data["items"] as List)
            .map((user) => UserProfileModel.fromMap(user))
            .toList();
      } else {
        throw Exception('Resposta inesperada da API');
      }
    } on http.ClientException catch (_) {
      throw Exception("Erro de conexão. Verifique sua internet.");
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  Future<void> accept({
    required int userId,
  }) async {
    try {
      String token = await _auth.token;
      final url = Uri.parse("$_baseUrl/api/v1/users/$userId/accept/");

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

  Future<void> refuse({
    required int userId,
  }) async {
    try {
      String token = await _auth.token;
      final url = Uri.parse("$_baseUrl/api/v1/users/$userId/refuse/");

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
