Liskov Substitution Principle (LSP)

👉 Subclasses should be replaceable with their base class without breaking.

Both repos respect IAuthRepo → no crashes.
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
```# 
[]: # In this example, `IUserRepo` is a large interface that includes methods for various user-related operations. If a class only needs to handle login and logout, it would still be forced to implement `updateProfile` and `deleteAccount`, which it doesn't use.
[]: # Instead, we can split the interface into smaller, more specific ones:
[]: # ```dart
[]: # abstract class IAuthRepo {
[]: #   Future<User> login(String email, String password);
[]: #   Future<void> logout();
[]: # }
[]: # 