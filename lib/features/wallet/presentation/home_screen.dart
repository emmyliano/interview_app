import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_session.dart';
import '../../../core/models/account.dart';
import '../../../core/models/result.dart';
import '../../../core/theme/app_theme.dart';
import '../../transactions/presentation/transactions_list.dart';
import '../data/wallet_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Account>> _accountsFuture;
  Account? _selectedAccount;
  bool _showBalance = true;
  bool _isLoadingBalance = false;
  double? _balance;

  @override
  void initState() {
    super.initState();
    _accountsFuture = _loadAccounts();
  }

  Future<List<Account>> _loadAccounts() async {
    final repository = context.read<WalletRepository>();
    final result = await repository.getAccounts();
    if (result is Success<List<Account>>) {
      final accounts = result.value;
      final session = context.read<AppSession>();
      if (session.selectedAccount == null && accounts.isNotEmpty) {
        await session.setSelectedAccount(accounts.first);
      }
      final selected = session.selectedAccount ?? accounts.first;
      setState(() {
        _selectedAccount = selected;
      });
      _loadBalance(selected.id);
      return accounts;
    }
    return const <Account>[];
  }

  Future<void> _loadBalance(String accountId) async {
    setState(() => _isLoadingBalance = true);
    final repository = context.read<WalletRepository>();
    final result = await repository.getBalance(accountId);
    if (!mounted) {
      return;
    }
    if (result is Success<double>) {
      setState(() {
        _balance = result.value;
        _isLoadingBalance = false;
      });
      return;
    }
    setState(() => _isLoadingBalance = false);
  }

  Future<void> _switchAccount(Account account) async {
    final session = context.read<AppSession>();
    final repository = context.read<WalletRepository>();
    await session.setSelectedAccount(account);
    setState(() {
      _selectedAccount = account;
    });
    await repository.switchAccount(account.id);
    await _loadBalance(account.id);
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AppSession>();
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good evening',
                          style: TextStyle(color: AppTheme.textSecondary.withOpacity(0.9)),
                        ),
                        Text(
                          session.currentUser?.name ?? 'Emmanuel',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.panelColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.notifications_none, color: AppTheme.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FutureBuilder<List<Account>>(
                future: _accountsFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final accounts = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        children: accounts.map((account) {
                          final selected = _selectedAccount?.id == account.id;
                          return ChoiceChip(
                            label: Text(account.currency),
                            selected: selected,
                            onSelected: (_) => _switchAccount(account),
                            selectedColor: AppTheme.accentColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF102235), Color(0xFF1E3A5F)],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Balance',
                                  style: TextStyle(color: AppTheme.textSecondary),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () => setState(() => _showBalance = !_showBalance),
                                  icon: Icon(
                                    _showBalance ? Icons.visibility : Icons.visibility_off,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (_isLoadingBalance)
                              const CircularProgressIndicator()
                            else if (_showBalance)
                              Text(
                                _balance != null
                                    ? '${_selectedAccount?.currency ?? 'NGN'} ${_balance!.toStringAsFixed(0)}'
                                    : '••••••',
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            else
                              const Text(
                                '••••••',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            const SizedBox(height: 12),
                            Text(
                              _selectedAccount?.name ?? 'Primary Account',
                              style: const TextStyle(color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text('Quick Actions', style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ActionPill(title: 'Deposit', icon: Icons.add_circle_outline, onTap: () {}),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionPill(title: 'Withdraw', icon: Icons.remove_circle_outline, onTap: () {}),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionPill(title: 'Trade', icon: Icons.swap_horiz, onTap: () {}),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Recent Transactions', style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              const TransactionsList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({required this.title, required this.icon, required this.onTap});

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.panelColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.accentSoft),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(color: AppTheme.textPrimary)),
          ],
        ),
      ),
    );
  }
}
