Don’t force classes to implement methods they don’t use.
The Interface Segregation Principle (ISP) states that no client should be forced to depend on methods it does not use. This means that larger interfaces should be split into smaller, more specific ones so that clients only need to know about the methods that are of interest to them.
In the context of authentication repositories, instead of having a single interface with methods for all types of authentication (e.g., email/password, OAuth, biometric), we can create separate interfaces for each type. This way, a class that only needs to handle email/password authentication doesn't have to implement methods related to OAuth or biometric authentication.
For example:

```dart
abstract class IUserRepo {
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<void> updateProfile(User user);
  Future<void> deleteAccount();
}
```
```dart
class EmailAuthRepo implements IUserRepo {
    @override
    
    Future<User> login(String email, String password) async {
        // Email/password login logic
    }
    @override
    Future<void> logout() async {
        // Email/password logout logic
    }
    @override
    Future<void> updateProfile(User user) async {
        throw UnimplementedError();
    }
    @override
    Future<void> deleteAccount() async {
        throw UnimplementedError();
    }
}
```