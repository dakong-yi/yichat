class User {
  final String username;
  final String email;
  final String userId;
  final String avatar;
  final String token;

  const User({
    required this.userId,
    required this.username,
    required this.email,
    required this.avatar,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? "",
      username: json['username'] ?? "",
      email: json['email'] ?? "",
      avatar: json['avatar'] ?? "",
      token: json['token'] ?? "",
    );
  }
}
