class User {
  final int? id;
  final String? username;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? token;

  const User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      token: json['token'],
    );
  }

  User copyWith({
    int? id,
    String? username,
    String? fullName,
    String? email,
    String? phone,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      token: token ?? this.token,
    );
  }
}
