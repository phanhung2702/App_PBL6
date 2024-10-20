class User {
  final String id;
  final String username;
  final String avatarUrl;

  User({required this.id, required this.username, required this.avatarUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      avatarUrl: json['avatarUrl'],
    );
  }
}