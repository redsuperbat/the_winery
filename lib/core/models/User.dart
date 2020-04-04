class User {
  String username;
  String email;
  String token;

  User({this.username, this.email, this.token});

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'username': username, 'token': token, 'email': email};

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    token = json['token'];
  }
}
