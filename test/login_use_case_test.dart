import 'package:flutter_test/flutter_test.dart';
import 'package:interview_app/features/auth/domain/login_use_case.dart';
import 'package:interview_app/features/auth/data/auth_repository.dart';
import 'package:interview_app/core/models/result.dart';

void main() {
  group('LoginUseCase', () {
    test('rejects empty credentials before calling repository', () async {
      final useCase = LoginUseCase(repository: MockAuthRepository());

      final result = await useCase.execute('', '');

      expect(result, isA<Failure>());
      expect((result as Failure).message, contains('Email'));
    });
  });
}
