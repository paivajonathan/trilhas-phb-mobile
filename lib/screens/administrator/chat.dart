import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/models/message.dart";
import "package:trilhas_phb/providers/user_data.dart";
import "package:trilhas_phb/services/chat.dart";
import "package:trilhas_phb/widgets/message_bubble.dart";

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chat = ChatService();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <MessageModel>[];
  bool _isLoadingMoreMessages = false;
  bool _isLoadingInitialMessages = true;
  late int _userId;

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();

    _chat.connect(_handleIncomingData);

    final userDataProvider = Provider.of<UserDataProvider>(
      context,
      listen: false,
    );
    _userId = userDataProvider.userData!.userId;
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
    if (data is List<MessageModel>) {
      if (_isLoadingInitialMessages) {
        setState(() => _isLoadingInitialMessages = false);
      }
      setState(() => _messages.insertAll(0, data));
    } else if (data is MessageModel) {
      setState(() => _messages.add(data));
      _scrollToBottom();
    }
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoadingMoreMessages) return;

    try {
      setState(() {
        _isLoadingMoreMessages = true;
      });

      final oldMessages = await _chat.get(olderThan: _messages.first.id);

      setState(() {
        _messages.insertAll(0, oldMessages);
      });
    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "");

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(content: Text(message)),
        );
    } finally {
      setState(() {
        _isLoadingMoreMessages = false;
      });
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
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        _loadMoreMessages();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: _isLoadingInitialMessages
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  : _messages.isEmpty
                      ? const Center(
                          child: Text("Ainda não foram enviados comunicados."),
                        )
                      : ListView.builder(
                          itemCount: _messages.length,
                          controller: _scrollController,
                          reverse: true,
                          itemBuilder: (context, index) {
                            final reversedMessages = _messages.reversed.toList();
                            final message = reversedMessages[index];
                            return MessageBubbleWidget(
                              chatMessage: message,
                              isMe: message.senderId == _userId,
                            );
                          },
                        ),
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Digite uma mensagem",
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary, width: 2.5),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary, width: 2.5),
                ),
                suffixIconColor: AppColors.primary,
                suffixIcon: IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
