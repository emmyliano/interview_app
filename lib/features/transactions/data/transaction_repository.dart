import '../../../core/models/result.dart';
import '../../../core/models/transaction.dart';

abstract class TransactionRepository {
  Future<Result<List<TransactionModel>>> getTransactions({required int limit, required int offset});
}

class MockTransactionRepository implements TransactionRepository {
  @override
  Future<Result<List<TransactionModel>>> getTransactions({required int limit, required int offset}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final transactions = <TransactionModel>[
      const TransactionModel(
        id: 't1',
        title: 'Salary deposit',
        amount: 250000,
        date: 'Today, 09:40',
        type: 'credit',
        status: 'Successful',
      ),
      const TransactionModel(
        id: 't2',
        title: 'Mobile recharge',
        amount: -5000,
        date: 'Yesterday',
        type: 'debit',
        status: 'Successful',
      ),
      const TransactionModel(
        id: 't3',
        title: 'Transfer to Ada',
        amount: -15000,
        date: 'Yesterday',
        type: 'debit',
        status: 'Pending',
      ),
    ];

    final page = transactions.skip(offset).take(limit).toList();
    return Success(page);
  }
}
