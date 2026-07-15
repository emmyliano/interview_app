import '../../../core/models/account.dart';
import '../../../core/models/result.dart';

abstract class WalletRepository {
  Future<Result<List<Account>>> getAccounts();
  Future<Result<double>> getBalance(String accountId);
  Future<Result<Account>> switchAccount(String accountId);
}

class MockWalletRepository implements WalletRepository {
  final List<Account> _accounts = const [
    Account(id: 'ngn', name: 'NGN Wallet', currency: 'NGN', balance: 125000),
    Account(id: 'usd', name: 'USD Wallet', currency: 'USD', balance: 5400),
  ];

  @override
  Future<Result<List<Account>>> getAccounts() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return Success(_accounts);
  }

  @override
  Future<Result<double>> getBalance(String accountId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final account = _accounts.firstWhere(
      (element) => element.id == accountId,
      orElse: () => _accounts.first,
    );
    return Success(account.balance);
  }

  @override
  Future<Result<Account>> switchAccount(String accountId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final account = _accounts.firstWhere(
      (element) => element.id == accountId,
      orElse: () => _accounts.first,
    );
    return Success(account);
  }
}
