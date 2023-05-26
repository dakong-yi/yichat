class Message {
  final String username;
  final String lastMessage;
  final String avatar;
  final String userId;
  final DateTime timestamp;

  Message({
    required this.avatar,
    required this.userId,
    required this.username,
    required this.lastMessage,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      userId: json['friendId'] ?? "",
      username: json['username'] ?? "",
      lastMessage: json['lastMessage'] ?? "",
      avatar: json['avatar'] ?? "",
      timestamp:
          DateTime.fromMillisecondsSinceEpoch(int.parse(json['timestamp'])),
    );
  }
}
