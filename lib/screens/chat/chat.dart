import "package:flutter/material.dart";
import "package:trilhas_phb/models/message.dart";
import "package:trilhas_phb/services/chat.dart";

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chat = ChatService();
  final _controller = TextEditingController();
  final _messages = <MessageModel>[]; // Lista para armazenar mensagens

  @override
  void initState() {
    super.initState();
    _chat.connect((message) {
      print(message);
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
                  return MessageBubbleWidget(chatMessage: _messages[index], isMe: true);
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


class MessageBubbleWidget extends StatelessWidget {
 const MessageBubbleWidget({
   Key? key,
   required this.chatMessage,
   required this.isMe,
 }) : super(key: key);
 
 final MessageModel chatMessage;
 final bool isMe;
 
 @override
 Widget build(BuildContext context) {
   return Column(
     crossAxisAlignment:
         isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
     children: [
       Row(
         mainAxisAlignment:
             isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
         children: [
           Container(
             padding: const EdgeInsets.all(10),
             margin: isMe
                 ? const EdgeInsets.only(right: 10)
                 : const EdgeInsets.only(left: 10),
             width: 200,
             decoration: BoxDecoration(
               color: isMe ? Colors.green : Colors.black12,
               borderRadius: BorderRadius.circular(10),
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   chatMessage.sender,
                   style: const TextStyle(fontSize: 13, color: Colors.white),
                 ),
                 const SizedBox(height: 5),
                 Text(
                   chatMessage.content,
                   style: const TextStyle(fontSize: 16, color: Colors.white),
                 ),
               ],
             ),
           ),
         ],
       ),
       MessageTimestampWidget(timestamp: chatMessage.timestamp),
     ],
   );
 }
}

class MessageTimestampWidget extends StatelessWidget {
 const MessageTimestampWidget({
   Key? key,
   required this.timestamp,
 }) : super(key: key);
 
 final DateTime timestamp;
 
 @override
 Widget build(BuildContext context) {
   final formattedTimestamp = timestamp.toString();
 
   return Container(
     margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
     child: Text(
       formattedTimestamp,
       style: const TextStyle(
           color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
     ),
   );
 }
}
