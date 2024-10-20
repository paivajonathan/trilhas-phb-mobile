import "dart:convert";

import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart" as http;
import "package:jwt_decode/jwt_decode.dart";

class AuthService {
  final storage = const FlutterSecureStorage();
  final apiUrl = "https://trilhas-phb-api.onrender.com/api/v1";
  
  Future<Map<String, dynamic>?> get user async {
    String? token = await storage.read(key: "jwt");
    String? user = await storage.read(key: "user");
      
    if (token == null || user == null) return null;

    bool isExpired = Jwt.isExpired(token);

    if (isExpired) return null;

    return json.decode(user);
  }

  Future<String?> get token async {
    return await storage.read(key: "jwt");
  }

  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse("$apiUrl/auth/token");
    
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      await storage.write(key: "jwt", value: responseData["token"]);
      await storage.write(key: "user", value: jsonEncode(responseData["user"]));
    }

    return response;
  }

  Future<http.Response> register(
    {
      required String email,
      required String password,
      
      required String fullName,
      required String birthDate,
      required String cellphone,
      required String neighborhoodName,
    }
  ) async {
    final url = Uri.parse("$apiUrl/users/");
    
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
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

    return response;
  }

  Future<void> logout() async {
    await storage.delete(key: "jwt");
    await storage.delete(key: "user");
  }
}