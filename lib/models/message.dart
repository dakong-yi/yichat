class ChatMessage {
  final String username;
  final String message;
  final String avatar;
  final String userId;
  final String recipient;
  final bool isSender;

  ChatMessage(
      {required this.avatar,
      required this.userId,
      required this.username,
      required this.message,
      required this.recipient,
      required this.isSender});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'message': message,
      'avatar': avatar,
      'userId': userId,
      'recipient': recipient,
      'isSender': isSender,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      userId: json['userId'] ?? "",
      username: json['username'] ?? "",
      message: "",
      avatar: json['avatar'] ?? "",
      recipient: "",
      isSender: false,
    );
  }
}
