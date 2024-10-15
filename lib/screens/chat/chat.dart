import "package:flutter/material.dart";
import "package:trilhas_phb/services/chat.dart";

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chat = ChatService();
  final _controller = TextEditingController();
  final _messages = []; // Lista para armazenar mensagens

  @override
  void initState() {
    super.initState();
    _chat.connect((message) {
      setState(() => _messages.add(message));
    });
  }

  @override
  void dispose() {
    _chat.leave();
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    _chat.send(_controller.text);
    _controller.clear();
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
              decoration: InputDecoration(labelText: "Send a message"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text("Send"),
            ),
          ],
        ),
      );
  }
}
