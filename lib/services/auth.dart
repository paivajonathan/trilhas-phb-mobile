import "dart:async";
import "dart:convert";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart" as http;
import "package:jwt_decode/jwt_decode.dart";
import "package:trilhas_phb/models/user.dart";
import "package:trilhas_phb/services/storage.dart";

class AuthService {
  final _apiUrl = dotenv.env["API_URL"];
  final _baseUrl = dotenv.env["BASE_URL"];
  
  final _storage = StorageService();
  
  Future<UserLoginModel?> get userData async {
    var (storedUserData, storedToken) = await _storage.loadKeys();

    if (storedUserData == null || storedToken == null) return null;

    if (Jwt.isExpired(storedToken)) return null;

    final userData = UserLoginModel.fromMap(json.decode(storedUserData));

    return userData;
  }

  Future<String> get token async {
    var (_, storedToken) = await _storage.loadKeys();
    return storedToken!;
  }

  Future<UserLoginModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse("$_apiUrl/auth/token/");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Origin": _baseUrl!,
        },
        body: json.encode({
          "email": email,
          "password": password,
        }),
      ).timeout(const Duration(seconds: 5));

      final responseStatus = response.statusCode;
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(
          responseData["detail"] ??
          responseData["message"] ??
          "Um erro inesperado ocorreu"
        );
      }

      final token = responseData["token"];
      final userData = {
        "id": responseData["user"]["id"],
        "type": responseData["user"]["user_type"],
      };

      await _storage.saveKeys(token, userData);

      return UserLoginModel.fromMap(userData);
    } on TimeoutException catch (_) {
      throw Exception("Tempo limite da requisição atingido.");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> register(
    {
      required String email,
      required String password,
      required String fullName,
      required String birthDate,
      required String cellphone,
      required String? neighborhoodName,
    }
  ) async {
    try {
      final url = Uri.parse("$_apiUrl/users/");
    
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Origin": _baseUrl!,
        },
        body: json.encode(
          {
            "user": {
              "email": email,
              "password": password,
            },
            "profile": {
              "full_name": fullName,
              "cellphone": cellphone,
              "birth_date": birthDate,
              "neighborhood_name": neighborhoodName,
            }
          }
        ),
      ).timeout(const Duration(seconds: 5));

      final responseStatus = response.statusCode;
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(
          responseData["detail"] ??
          responseData["message"] ??
          "Um erro inesperado ocorreu"
        );
      }
    } on TimeoutException catch (_) {
      throw Exception("Tempo limite da requisição atingido.");
    } catch (e) {
      throw Exception(e);
    }    
  }

  Future<void> logout() async {
    await _storage.destroyKeys();
  }
}