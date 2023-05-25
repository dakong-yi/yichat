class Contact {
  final String username;
  final String email;
  final String userId;
  final String avatar;

  const Contact(
      {required this.userId,
      required this.username,
      required this.email,
      required this.avatar});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      userId: json['userId'],
      username: json['username'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }
}

Map<String, Contact> cachedContacts = {};
