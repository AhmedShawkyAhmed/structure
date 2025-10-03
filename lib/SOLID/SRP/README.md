AuthService → only does API calls.
AuthRepo → only does mapping business logic & DTO.

```dart
class AuthService {
  Future<UserDTO> login(String email, String password) async {
    // API call logic
  } 
    Future<void> logout() async {
        // API call logic
    }
}
```
```dart
class AuthRepo {
    final AuthService authService;  
    AuthRepo(this.authService);
    Future<User> login(String email, String password) async {
        final userDTO = await authService.login(email, password);
        return User.fromDTO(userDTO); // Mapping logic
    }
    Future<void> logout() async {
        await authService.logout();
    }
}
```
```dart
class User {
    final String id;
    final String email;
    User({required this.id, required this.email});
    factory User.fromDTO(UserDTO dto) {
        return User(id: dto.id, email: dto.email);
    }
}
class UserDTO {
    final String id;
    final String email;
    UserDTO({required this.id, required this.email});
}
```
This way, each class has a single responsibility, making the codebase easier to maintain and extend
[]: # In this refactored example, we have separated the concerns of making API calls and handling business logic. The `AuthService` class is responsible for making the actual API calls, while the `AuthRepo` class handles the mapping of data transfer objects (DTOs) to domain models and any additional business logic. This adheres to the Single Responsibility Principle (SRP) by ensuring that each class has one reason to change.
