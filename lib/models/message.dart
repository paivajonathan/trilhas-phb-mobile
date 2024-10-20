class MessageModel {
  final String content;
  final String sender;
  final DateTime timestamp;

  MessageModel({
    required this.content,
    required this.sender,
    required this.timestamp,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    const millisecondsInSeconds = 1000;

    return MessageModel(
      content: map["content"] ?? "",
      sender: map["sender"] ?? "",
      timestamp: DateTime.fromMillisecondsSinceEpoch(map["timestamp"] * millisecondsInSeconds),
    );
  }
}