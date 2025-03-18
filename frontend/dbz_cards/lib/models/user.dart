// ignore_for_file: non_constant_identifier_names

class User {
  final int id;
  final String username;
  final String password;
  final String email;
  final String bio;
  final String avatar_url;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.bio,
    required this.avatar_url,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      bio: json['bio'] ?? '',
      avatar_url: json['avatar_url'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'bio': bio,
      'avatar_url': avatar_url,
    };
  }


  
}