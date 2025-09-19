import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure/architecture/clean/data/data_source/auth_remote_data_source.dart';
import 'package:structure/architecture/clean/data/repositories/auth_repo_impl.dart';
import 'package:structure/architecture/clean/domain/usecases/login_usecase.dart';
import '../bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return RepositoryProvider(
      create: (_) => AuthRepositoryImpl(AuthRemoteDataSource()),
      child: BlocProvider(
        create: (context) => LoginBloc(LoginUseCase(context.read())),
        child: Scaffold(
          appBar: AppBar(title: const Text('Login (Clean + BLoC)')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginFailure) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error)));
                    }
                    if (state is LoginSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Welcome ${state.user.email}!')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        context.read<LoginBloc>().add(
                          LoginButtonPressed(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          ),
                        );
                      },
                      child: const Text('Login'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
