import "package:flutter/material.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/models/message.dart";
import "package:trilhas_phb/services/chat.dart";

class ChatScreen extends StatefulWidget {
  final int userId;
  
  const ChatScreen({super.key, required this.userId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chat = ChatService();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <MessageModel>[];

  @override
  void initState() {
    super.initState();
    _chat.connect((data) {
      _handleIncomingData(data);
    });
  }

  @override
  void dispose() {
    _chat.leave();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;
    _chat.send(_messageController.text);
    _messageController.clear();
  }

  void _handleIncomingData(dynamic data) {
    if (data is List<MessageModel>){
      setState(() => _messages.insertAll(0, data));
    } else {
      setState(() => _messages.add(data));
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: _messages.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : ListView.builder(
                itemCount: _messages.length,
                controller: _scrollController,
                reverse: true,
                itemBuilder: (context, index) {
                  final reversedMessages = _messages.reversed.toList();
                  final message = reversedMessages[index];
                  return MessageBubbleWidget(chatMessage: message, isMe: message.senderId == widget.userId);
                },
              ),
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Digite uma mensagem",
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary, width: 2.5)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary, width: 2.5)),
                suffixIconColor: AppColors.primary,
                suffixIcon: IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ),
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
               color: isMe ? AppColors.primary : Colors.black12,
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
