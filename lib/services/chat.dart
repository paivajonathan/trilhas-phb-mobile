import "dart:convert";

import "package:trilhas_phb/models/message.dart";
import "package:trilhas_phb/services/auth.dart";
import "package:web_socket_channel/io.dart";
import "package:web_socket_channel/web_socket_channel.dart";

class ChatService {
  final _auth = AuthService();
  late WebSocketChannel _channel;

  Future<void> connect(void Function(dynamic)? onData) async {
    String? token = await _auth.token;
    Uri wsUrl = Uri.parse("wss://trilhas-phb-api.onrender.com/ws/chat/");
    
    _channel = IOWebSocketChannel.connect(
      wsUrl,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Origin": "wss://trilhas-phb-api.onrender.com",
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

  void send(String message) {
    _channel.sink.add(message);
  }

  void leave() {
    _channel.sink.close();
  }
}