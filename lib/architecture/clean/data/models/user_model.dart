import '../../domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.email,
    required super.token,
    required super.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      token: json['token'],
    );
  }
}
