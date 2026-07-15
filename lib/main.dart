import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_session.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/navigation/app_shell.dart';
import 'features/transactions/data/transaction_repository.dart';
import 'features/wallet/data/wallet_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final session = AppSession(preferences: preferences);
  await session.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: session),
        Provider<AuthRepository>(create: (_) => MockAuthRepository()),
        Provider<WalletRepository>(create: (_) => MockWalletRepository()),
        Provider<TransactionRepository>(create: (_) => MockTransactionRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AppSession>();

    return MaterialApp(
      title: 'MonieHub Lite',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: session.isLoggedIn ? const AppShell() : const LoginScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const AppShell(),
      },
    );
  }
}