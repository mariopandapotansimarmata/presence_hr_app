class User {
  final String userName;
  final String name;
  final String password;

  User({
    required this.userName,
    required this.name,
    required this.password,
  });

  // Convert the object to JSON
  Map<String, Object?> toJson() => {
        "user_name": userName,
        "name": name,
        "password": password,
      };

  // Create an object from JSON
  factory User.fromJson(Map<String, Object?> json) => User(
        userName: json["user_name"] as String,
        name: json["name"] as String,
        password: json["password"] as String,
      );
}
