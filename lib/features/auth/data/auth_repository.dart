import 'dart:async';

import '../../../core/models/result.dart';
import '../../../core/models/user.dart';

abstract class AuthRepository {
  Future<Result<User>> login(String email, String password);
  Future<Result<User>> loginWithGoogle();
  Future<Result<User>> loginWithApple();
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<Result<User>> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    if (trimmedEmail.isEmpty || trimmedPassword.length < 4) {
      return const Failure('Please provide a valid email and password.');
    }

    return Success(User(
      id: trimmedEmail,
      name: 'User',
      email: trimmedEmail,
    ));
  }

  @override
  Future<Result<User>> loginWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const Failure('Google sign-in is not available in this demo.');
  }

  @override
  Future<Result<User>> loginWithApple() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const Failure('Apple sign-in is not available in this demo.');
  }
}
