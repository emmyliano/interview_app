import 'package:flutter/material.dart';

import '../../../core/models/result.dart';
import '../../../core/models/transaction.dart';
import '../../../core/theme/app_theme.dart';
import '../data/transaction_repository.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({super.key});

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  late Future<List<TransactionModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<TransactionModel>> _load() async {
    final repository = MockTransactionRepository();
    final result = await repository.getTransactions(limit: 5, offset: 0);
    if (result is Success<List<TransactionModel>>) {
      return result.value;
    }
    return const <TransactionModel>[];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TransactionModel>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No transactions yet', style: TextStyle(color: AppTheme.textSecondary)),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final transaction = snapshot.data![index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.panelColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: transaction.type == 'credit' ? AppTheme.successColor : AppTheme.accentSoft,
                    child: Icon(
                      transaction.type == 'credit' ? Icons.arrow_downward : Icons.arrow_upward,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.title,
                          style: const TextStyle(color: AppTheme.textPrimary),
                        ),
                        Text(
                          transaction.date,
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${transaction.amount > 0 ? '+' : ''}${transaction.amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: transaction.amount > 0 ? AppTheme.successColor : AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        transaction.status,
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
