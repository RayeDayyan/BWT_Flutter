import 'package:task_7_buddyup/models/user_model.dart';

class UserModel {
  String? UserID;
  final String Name;
  final int Age;
  final String Email;
  String? Bio;
  String? Profile;
  final String Contact;
  final String Emergency;
  final String Password;

  UserModel(
      {this.UserID,
      required this.Name,
      required this.Age,
      required this.Email,
      this.Bio,
      this.Profile,
      required this.Contact,
      required this.Emergency,
      required this.Password});

  Map<String, dynamic> toJson() {
    return {
      'uid': UserID,
      'name': Name,
      'age': Age,
      'email': Email,
      'contact': Contact,
      'emergency': Emergency,
      'password': Password
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      UserID: json['uid'],
      Name: json['name'],
      Age: json['age'],
      Email: json['email'],
      Contact: json['contact'],
      Emergency: json['emergency'],
      Password: json['password'],
      Bio: json['bio'] ?? 'dummybio',
      Profile: json['profile'] ?? null,
    );
  }
}
