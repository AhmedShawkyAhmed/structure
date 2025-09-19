import 'package:flutter/foundation.dart';

import '../model/user_model.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  User? _user;
  bool _isLoading = false;

  UserViewModel(this._userRepository);

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();
    _user = await _userRepository.fetchUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUserName(String newName) async {
    if (_user != null) {
      _user!.name = newName;
      await _userRepository.updateUser(_user!);
      notifyListeners();
    }
  }
}