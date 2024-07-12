class UserModel {
  final String uid;
  final String username;
  final String email;

  UserModel({required this.uid, required this.username, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
    };
  }
}
