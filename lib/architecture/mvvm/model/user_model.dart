class User {
  final String id;
  String name;
  String email;

  User({required this.id, required this.name, required this.email});
}

class UserRepository {
  // Simulate data source
  User _currentUser = User(id: '1', name: 'John Doe', email: 'john@example.com');

  Future<User> fetchUser() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    return _currentUser;
  }

  Future<void> updateUser(User updatedUser) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    _currentUser = updatedUser;
  }
}