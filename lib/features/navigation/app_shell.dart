import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../auth/presentation/login_screen.dart';
import '../transactions/presentation/transactions_list.dart';
import '../wallet/presentation/home_screen.dart';
import 'placeholder_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    PlaceholderScreen(title: 'Services'),
    PlaceholderScreen(title: 'Wallets'),
    PlaceholderScreen(title: 'Cards'),
    PlaceholderScreen(title: 'Account'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppTheme.panelColor,
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.widgets_outlined), label: 'Services'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallets'),
          NavigationDestination(icon: Icon(Icons.credit_card_outlined), label: 'Cards'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Account'),
        ],
      ),
    );
  }
}
