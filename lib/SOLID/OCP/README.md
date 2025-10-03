Open/Closed Principle (OCP)

👉 Classes should be open for extension but closed for modification.

✅ Example: if tomorrow you replace REST with Firebase, you don’t edit all code, just provide a new implementation.

```dart
abstract class IAuthRepo {
  Future<User> login(String email, String password);
  Future<void> logout();
}
```
```dart
class EmailAuthRepo implements IAuthRepo {      
    @override
    Future<User> login(String email, String password) async {
        // Email/password login logic
    }
    
    @override
    Future<void> logout() async {
        // Email/password logout logic
    }
    }
```
```dart
class OAuthRepo implements IAuthRepo {
    @override
    Future<User> login(String email, String password) async {
        // OAuth login logic
    }
    @override
    Future<void> logout() async {
        // OAuth logout logic
    }
}
```