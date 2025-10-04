import 'package:core_utils/core_utils.dart';

//Factory Constructor (Dart’s built-in feature)
class User {
  final String role;
  final String name;

  User._(this.role, this.name);

  factory User.admin(String name) {
    return User._('Admin', name);
  }

  factory User.client(String name) {
    return User._('Client', name);
  }
}

void main() {
  final admin = User.admin('Ahmed');
  final client = User.client('Shawky');

  AppLogs.debugLog('${admin.name} is ${admin.role}'); // Ahmed is Admin
  AppLogs.debugLog(('${client.name} is ${client.role}')); // Shawky is Client
}
