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
    _scrollController.addListener(_onScroll);

    final userDataProvider = Provider.of<UserDataProvider>(
      context,
      listen: false,
    );
    _userId = userDataProvider.userData!.id;
  }

  @override
  void dispose() {
    _chat.leave();
    super.dispose();
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

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMoreMessages();
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
    return Padding(
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
        ],
      ),
    );
  }
}
