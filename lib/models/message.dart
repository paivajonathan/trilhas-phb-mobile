class MessageModel {
  final int id;
  final String content;
  final int senderId;
  final String sender;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.content,
    required this.senderId,
    required this.sender,
    required this.timestamp,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    const millisecondsInSeconds = 1000;

    return MessageModel(
      id: map["id"],
      content: map["content"],
      senderId: map["sender_id"],
      sender: map["sender"],
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        map["timestamp"] * millisecondsInSeconds
      ),
    );
  }
}