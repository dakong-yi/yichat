class FriendRequest {
  final String id;
  final String username;
  final String email;
  final String avatar;
  int status; // 添加状态属性

  FriendRequest({
    required this.id,
    required this.username,
    required this.email,
    required this.avatar,
    required this.status,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['userId'],
      username: json['username'],
      email: json['email'],
      avatar: json['avatar'],
      status: json['status'],
    );
  }
}
