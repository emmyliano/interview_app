import '../../../core/models/result.dart';
import '../../../core/models/user.dart';
import '../data/auth_repository.dart';

class LoginUseCase {
  LoginUseCase({required this.repository});

  final AuthRepository repository;

  Future<Result<User>> execute(String email, String password) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    if (trimmedEmail.isEmpty) {
      return const Failure('Email is required.');
    }

    if (!trimmedEmail.contains('@')) {
      return const Failure('Please enter a valid email address.');
    }

    if (trimmedPassword.isEmpty) {
      return const Failure('Password is required.');
    }

    try {
      return repository.login(trimmedEmail, trimmedPassword);
    } catch (error) {
      return Failure('Unable to sign in right now: $error');
    }
  }
}
