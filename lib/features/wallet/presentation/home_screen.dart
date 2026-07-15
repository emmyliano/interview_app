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
    final session = context.read<AppSession>();
    final result = await repository.getAccounts();
    if (!mounted) {
      return const <Account>[];
    }

    if (result is Success<List<Account>>) {
      final accounts = result.value;
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
      body: FutureBuilder<List<Account>>(
        future: _accountsFuture,
        builder: (context, snapshot) {
          final accounts = snapshot.data ?? const <Account>[];
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topRight,
                      radius: 1.4,
                      colors: [Color(0xFF101C2F), Color(0xFF03060C)],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
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
                                  style: TextStyle(
                                    color: AppTheme.textSecondary.withOpacity(0.85),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  session.currentUser?.name ?? 'User',
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.panelColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.notifications_none,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          if (accounts.isEmpty)
                            const Expanded(
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else
                            Expanded(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: accounts.map((account) {
                                  final selected = _selectedAccount?.id == account.id;
                                  return ChoiceChip(
                                    label: Text(account.currency),
                                    selected: selected,
                                    onSelected: (_) => _switchAccount(account),
                                    selectedColor: AppTheme.accentColor,
                                    labelStyle: TextStyle(
                                      color: selected ? Colors.white : AppTheme.textPrimary,
                                    ),
                                    backgroundColor: AppTheme.panelColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                            const SizedBox(height: 12),
                            if (_isLoadingBalance)
                              const Center(child: CircularProgressIndicator())
                            else
                              Text(
                                _showBalance
                                    ? '${_selectedAccount?.currency ?? 'NGN'} ${_balance?.toStringAsFixed(0) ?? '• • • • • •'}'
                                    : '••••••',
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            const SizedBox(height: 10),
                            Text(
                              _selectedAccount?.name ?? 'Primary account',
                              style: const TextStyle(color: AppTheme.textSecondary),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.south_west, size: 18),
                                    label: const Text('Deposit'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.accentColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.north_east, size: 18),
                                    label: const Text('Withdraw'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2A2A2E),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.bar_chart, size: 18),
                                    label: const Text('Trade'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2A2A2E),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick actions',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            _IconGridItem(label: 'Pay bills', icon: Icons.request_page),
                            _IconGridItem(label: 'Giftcards', icon: Icons.card_giftcard),
                            _IconGridItem(label: 'Crypto', icon: Icons.currency_bitcoin),
                            _IconGridItem(label: 'Cards', icon: Icons.credit_card),
                          ],
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Billers',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: const [
                            _BillerChip(label: 'MTN', color: Color(0xFFFFC800)),
                            _BillerChip(label: 'Airtel', color: Color(0xFFED1C24)),
                            _BillerChip(label: 'Glo', color: Color(0xFF00A651)),
                            _BillerChip(label: 'Startimes', color: Color(0xFF1D9BF0)),
                            _BillerChip(label: 'DSTV', color: Color(0xFF00205B)),
                            _BillerChip(label: 'EKEDC', color: Color(0xFF2E1A47)),
                            _BillerChip(label: 'GOTV', color: Color(0xFFF6B93B)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Recent transactions',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const TransactionsList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _IconGridItem extends StatelessWidget {
  const _IconGridItem({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F5FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: AppTheme.accentColor, size: 26),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _BillerChip extends StatelessWidget {
  const _BillerChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 28,
            width: 28,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              label[0],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.black87)),
        ],
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
