High-level modules (Cubit/UI) should depend on abstractions, not concrete classes.

[]: # The Dependency Inversion Principle (DIP) states that high-level modules should not depend on low-level modules. Both should depend on abstractions. Additionally, abstractions should not depend on details; details should depend on abstractions. This principle helps to reduce the coupling between different parts of a system, making it more flexible and easier to maintain.
[]: # In the context of authentication repositories, instead of having the UI or Cubit directly depend on a concrete implementation of an authentication repository (e.g., EmailAuthRepo), we can define an abstract interface (e.g., IAuthRepo) that both the UI/Cubit and the concrete implementations depend on. This way, we can easily swap out different implementations without affecting the high-level modules.
[]: # For example:
[]: # 
[]: # ```dart
[]: # abstract class IAuthRepo {
[]: #   Future<User> login(String email, String password);
[]: #   Future<void> logout();
[]: # }
[]: # ```
[]: # ```dart
[]: # class EmailAuthRepo implements IAuthRepo {
[]: #     @override
[]: #     
[]: #     Future<User> login(String email, String password) async {
[]: #         // Email/password login logic
[]: #     }
[]: #     @override
[]: #     Future<void> logout() async {
[]: #         // Email/password logout logic
[]: #     }
[]: # }
[]: # ```
[]: # ```dart
[]: # class AuthCubit extends Cubit<AuthState> {
[]: #   final IAuthRepo authRepo;
[]: # 
[]: #   AuthCubit(this.authRepo) : super(AuthInitial());
[]: # 
[]: #   Future<void> login(String email, String password) async {
[]: #     try {
[]: #       emit(AuthLoading());
[]: #       final user = await authRepo.login(email, password);
[]: #       emit(AuthAuthenticated(user));
[]: #     } catch (e) {
[]: #       emit(AuthError(e.toString()));
[]: #     }
[]: #   }
[]: # 
[]: #   Future<void> logout() async {
[]: #     try {
[]: #       emit(AuthLoading());
[]: #       await authRepo.logout();
[]: #       emit(AuthUnauthenticated());
[]: #     } catch (e) {
[]: #       emit(AuthError(e.toString()));
[]: #     }
[]: #   }
[]: # }
[]: # ```
[]: # In this example, `IAuthRepo` is an abstraction that defines the contract for authentication repositories. `EmailAuthRepo` is a concrete implementation of this interface. The `AuthCubit` depends on the `IAuthRepo` abstraction rather than a specific implementation. This allows for greater flexibility, as we can easily switch to a different authentication repository (e.g., OAuthRepo) without modifying the `AuthCubit` class.
[]: # This adherence to the Dependency Inversion Principle (DIP) helps to create a more modular and maintainable codebase.
