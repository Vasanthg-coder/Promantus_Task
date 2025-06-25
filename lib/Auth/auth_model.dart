class UserModel {
  final String username;
  final String name;
  final String email;
  final String password;

  UserModel({
    required this.username,
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'name': name,
        'email': email,
        'password': password,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        username: json['username'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
      );
}
