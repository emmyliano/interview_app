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

    if (email.trim().toLowerCase() == 'akemuemmy@gmail.com' &&
        password.trim().length >= 4) {
      return Success(User(
        id: 'demo-user',
        name: 'Emmanuel',
        email: email.trim(),
      ));
    }

    return const Failure('Invalid credentials. Please try demo@moniehub.com.');
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
