import "dart:async";
import "dart:convert";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart" as http;
import "package:jwt_decode/jwt_decode.dart";
import "package:trilhas_phb/models/user_data.dart";
import "package:trilhas_phb/services/storage.dart";

class AuthService {
  final _baseUrl = dotenv.env["BASE_URL"];
  final _storage = StorageService();
  
  Future<UserDataModel?> get userData async {
    var (storedUserData, storedToken) = await _storage.loadKeys();

    if (storedUserData == null || storedToken == null) return null;

    if (Jwt.isExpired(storedToken)) return null;

    final userData = UserDataModel.fromMap(json.decode(storedUserData));

    return userData;
  }

  Future<String> get token async {
    var (_, storedToken) = await _storage.loadKeys();
    return storedToken!;
  }

  Future<void> logout() async {
    await _storage.destroyKeys();
  }

  Future<UserDataModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse("$_baseUrl/api/v1/auth/token/");

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
      ).timeout(const Duration(seconds: 10));

      final responseStatus = response.statusCode;
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(
          responseData["detail"] ?? responseData["message"] ?? "Um erro inesperado ocorreu"
        );
      }

      final token = responseData["token"];
      final userData = {
        "id": responseData["user"]["id"],
        "type": responseData["user"]["user_type"],
      };

      await _storage.saveKeys(token, userData);

      return UserDataModel.fromMap(userData);
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
      final url = Uri.parse("$_baseUrl/api/v1/users/");
    
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

  Future<String> sendConfirmationCode(
    {
      required String email,
    }
  ) async {
    try {
      final url = Uri.parse("$_baseUrl/api/v1/auth/send-confirmation-code/");
    
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Origin": _baseUrl!,
        },
        body: json.encode(
          {
            "email": email,
          }
        ),
      ).timeout(const Duration(seconds: 10));

      final responseStatus = response.statusCode;
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(
          responseData["detail"] ?? responseData["message"] ?? "Um erro inesperado ocorreu"
        );
      }

      return responseData["message"];
    } on TimeoutException catch (_) {
      throw Exception("Tempo limite da requisição atingido.");
    } catch (e) {
      throw Exception(e);
    }    
  }

  Future<String> checkConfirmationCode(
    {
      required String email,
      required String confirmationCode,
    }
  ) async {
    try {
      final url = Uri.parse("$_baseUrl/api/v1/auth/check-confirmation-code/");
    
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Origin": _baseUrl!,
        },
        body: json.encode(
          {
            "email": email,
            "confirmation_code": confirmationCode,
          }
        ),
      ).timeout(const Duration(seconds: 10));

      final responseStatus = response.statusCode;
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(
          responseData["detail"] ?? responseData["message"] ?? "Um erro inesperado ocorreu"
        );
      }

      return responseData["message"];
    } on TimeoutException catch (_) {
      throw Exception("Tempo limite da requisição atingido.");
    } catch (e) {
      throw Exception(e);
    }    
  }

  Future<String> changePassword(
    {
      required String email,
      required String confirmationCode,
      required String newPassword,
    }
  ) async {
    try {
      final url = Uri.parse("$_baseUrl/api/v1/auth/change-password/");
    
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Origin": _baseUrl!,
        },
        body: json.encode(
          {
            "email": email,
            "confirmation_code": confirmationCode,
            "password": newPassword,
          }
        ),
      ).timeout(const Duration(seconds: 10));

      final responseStatus = response.statusCode;
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (![200, 201].contains(responseStatus)) {
        throw Exception(
          responseData["detail"] ?? responseData["message"] ?? "Um erro inesperado ocorreu"
        );
      }

      return responseData["message"];
    } on TimeoutException catch (_) {
      throw Exception("Tempo limite da requisição atingido.");
    } catch (e) {
      throw Exception(e);
    }    
  }
}
