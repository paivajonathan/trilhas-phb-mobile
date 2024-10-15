import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late WebSocketChannel _channel;
  TextEditingController _controller = TextEditingController();
  List<String> _messages = []; // Lista para armazenar mensagens

  @override
  void initState() {
    super.initState();
    final wsUrl = Uri.parse('wss://trilhas-phb-api.onrender.com/ws/chat/?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzI5MDcxNzkwLCJpYXQiOjE3MjkwMDY5OTAsImp0aSI6Ijk2ZTc0M2QwMTNlZDQ2MTI4YjEwOTkzYjlmOWEwZTNlIiwidXNlcl9pZCI6MX0.K1zgMn6aXl9CGqRW8HA-62-qu-EZ17bfbdXuwQU4y9M');
    _channel = IOWebSocketChannel.connect(
      wsUrl,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Origin': 'wss://trilhas-phb-api.onrender.com',
      },
    );
    print("Conexão realizada!");

    // Escutando as mensagens recebidas
    _channel.stream.listen((message) {
      setState(() {
        _messages.add(message); // Adiciona a nova mensagem à lista
      });
    });
  }

  @override
  void dispose() {
    _channel.sink.close(); // Fecha a conexão WebSocket ao dispensar a tela
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text); // Envia a mensagem para o servidor
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Mensagem: " + _messages[index]), // Exibe cada mensagem
                  );
                },
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send'),
            ),
          ],
        ),
      );
  }
}
