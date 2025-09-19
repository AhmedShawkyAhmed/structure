import 'package:structure/architecture/mvp/model/user_model.dart';
import 'package:structure/architecture/mvp/view/login_screen.dart';

class UserPresenter {
  UserViewContract? _view; // Use a nullable type for the contract

  void initView(UserViewContract view) {
    _view = view;
  }

  void loadUser() {
    // Simulate fetching user data from a data source (e.g., API, database)
    // In a real application, this would involve calling a service or repository
    final User user = User(name: 'John Doe', email: 'john.doe@example.com');
    _view?.displayUser(user); // Update the view with the fetched data
  }
}