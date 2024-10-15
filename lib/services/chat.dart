import 'package:trilhas_phb/services/auth.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {
  final _auth = AuthService();
  late WebSocketChannel _channel;

  Future<void> connect(void Function(dynamic)? onData) async {
    String? token = await _auth.token;
    Uri wsUrl = Uri.parse("wss://trilhas-phb-api.onrender.com/ws/chat/?token=$token");
    
    _channel = IOWebSocketChannel.connect(
      wsUrl,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Origin": "wss://trilhas-phb-api.onrender.com",
      },
    );

    _channel.stream.listen(onData);
  }

  void send(String message) {
    _channel.sink.add(message);
  }

  void leave() {
    _channel.sink.close();
  }
}