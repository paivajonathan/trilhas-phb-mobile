import "dart:convert";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart" as http;
import "package:jwt_decode/jwt_decode.dart";
import "package:result_dart/result_dart.dart";
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

  AsyncResult<UserLoginModel, String> login({
    required String email,
    required String password,
  }) async {
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
    );

    final responseStatus = response.statusCode;
    final responseData = json.decode(response.body) as Map<String, dynamic>;

    if (responseStatus == 200) {
      final token = responseData["token"];
      final userData = {
        "id": responseData["user"]["id"],
        "type": responseData["user"]["user_type"],
      };

      await _storage.saveKeys(token, userData);

      return Success(UserLoginModel.fromMap(userData));
    }

    return Failure(responseData["detail"] ?? responseData["message"] ?? "An unexpected error occurred");
  }

  AsyncResult<String, String> register(
    {
      required String email,
      required String password,
      required String fullName,
      required String birthDate,
      required String cellphone,
      required String neighborhoodName,
    }
  ) async {
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
    );

    final responseStatus = response.statusCode;
    final responseData = json.decode(response.body) as Map<String, dynamic>;

    if (responseStatus == 200) {
      return const Success("Ok");
    }

    return Failure(responseData["detail"] ?? responseData["message"] ?? "An unexpected error occurred");
  }

  Future<void> logout() async {
    await _storage.destroyKeys();
  }
}