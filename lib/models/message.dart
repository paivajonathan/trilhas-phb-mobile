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
          map["timestamp"] * millisecondsInSeconds),
    );
  }

  String get readableDate {
    return "${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year}";
  }

  String get readableTime {
    return "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
  }

  String get readableTimestamp {
    return "$readableDate $readableTime";
  }

  String get readableSender {
    final names = sender.split(" ");

    if (names.length == 1) {
      return names.first;
    }

    return "${names.first} ${names.last}";
  }
}
