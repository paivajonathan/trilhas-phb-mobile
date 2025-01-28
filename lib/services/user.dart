import 'dart:convert';
import "dart:async";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:trilhas_phb/models/user_data.dart';
import 'package:trilhas_phb/services/auth.dart';

class UserService {
  final String _baseUrl = dotenv.env["BASE_URL"]!;
  final _auth = AuthService();

  Future<List<UserProfileModel>> fetchUsers() async {
    String token = await _auth.token;

    final uri = Uri.parse("$_baseUrl/api/v1/users/");

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
}
