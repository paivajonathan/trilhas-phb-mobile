import "dart:async";
import "dart:convert";

import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart" as http;
import "package:trilhas_phb/models/message.dart";
import "package:trilhas_phb/services/auth.dart";
import "package:web_socket_channel/io.dart";
import "package:web_socket_channel/web_socket_channel.dart";

class ChatService {
  final _apiUrl = dotenv.env["API_URL"]!;
  final _websocketUrl = dotenv.env["WEBSOCKET_URL"]!;
  final _baseUrl = dotenv.env["BASE_URL"]!;

  final _auth = AuthService();
  late WebSocketChannel _channel;

  Future<void> connect(void Function(dynamic)? onData) async {
    final token = await _auth.token;
    
    Uri wsUrl = Uri.parse("$_websocketUrl/ws/chat/");
    
    _channel = IOWebSocketChannel.connect(
      wsUrl,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Origin": _baseUrl,
        "Authorization": "Bearer $token",
      },
    );

    _channel.stream.listen((value) {
      var decodedJson = json.decode(value) as Map<String, dynamic>;
      String eventType = decodedJson["type"];

      switch (eventType) {
        case "chat_message":
          var message = MessageModel.fromMap(decodedJson);
          if (onData != null) onData(message);
          break;
        case "recent_messages":
          List<MessageModel> recentMessages = (decodedJson["messages"] as List)
            .reversed
            .map((messageJson) => MessageModel.fromMap(messageJson))
            .toList();
          if (onData != null) onData(recentMessages);
          break;
      }
    });
  }

  Future<List<MessageModel>> get({int? olderThan}) async {
    String token = await _auth.token;
    
    String urlString = "$_apiUrl/chat-messages/";
    
    if (olderThan != null) {
      urlString += "?older_than=$olderThan&ordering=-registration&page=1&page_size=25";
    }
    
    final url = Uri.parse(urlString);

    try {
      final response = await http.get(
        url,
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
          responseData["detail"] ??
          responseData["message"] ??
          "Um erro inesperado ocorreu"
        );
      }

      List<MessageModel> recentMessages = (responseData["items"] as List)
        .reversed
        .map((messageJson) => MessageModel.fromMap(messageJson))
        .toList();

      return recentMessages;
    } on TimeoutException catch (_) {
      throw Exception("Tempo limite da requisição atingido.");
    } catch (e) {
      throw Exception(e);
    }
  }

  void send(String message) {
    _channel.sink.add(message);
  }

  void leave() {
    _channel.sink.close();
  }
}