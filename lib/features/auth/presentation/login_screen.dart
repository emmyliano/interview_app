import 'package:flutter/material.dart';
import 'package:interview_app/core/models/user.dart';
import 'package:provider/provider.dart';

import '../../../app_session.dart';
import '../../../core/models/result.dart';
import '../../../core/theme/app_theme.dart';
import '../data/auth_repository.dart';
import '../domain/login_use_case.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'demo@moniehub.com');
  final _passwordController = TextEditingController(text: 'demo123');
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final session = context.read<AppSession>();
    final repository = context.read<AuthRepository>();
    final useCase = LoginUseCase(repository: repository);

    final result = await useCase.execute(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (result is Success<User>) {
      final user = result.value;
      await session.login(user);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
      return;
    } else if (result is Failure<User>) {
      setState(() => _errorMessage = result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top black area
            Container(
              width: double.infinity,
              color: AppTheme.backgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 8),
                  Text(
                    'MonieHub Lite',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Securely manage your wallet and transfers',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),

            // White bottom sheet with form
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.black87),
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Email is required';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Password is required';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        if (_errorMessage != null) ...[
                          Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)),
                          const SizedBox(height: 12),
                        ],
                        ElevatedButton(
                          onPressed: _isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: AppTheme.accentColor,
                            foregroundColor: Colors.white,
                          ),
                          child: _isSubmitting
                              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Login'),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Expanded(child: Divider(color: Colors.black26)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text('or continue with', style: TextStyle(color: Colors.black54)),
                            ),
                            Expanded(child: Divider(color: Colors.black26)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.g_mobiledata, color: Colors.black54),
                                label: const Text('Google', style: TextStyle(color: Colors.black87)),
                                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black12)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.apple, color: Colors.black54),
                                label: const Text('Apple', style: TextStyle(color: Colors.black87)),
                                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black12)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(onPressed: () {}, child: const Text('Forgot password', style: TextStyle(color: Colors.black87))),
                            TextButton(onPressed: () {}, child: const Text('Create account', style: TextStyle(color: Colors.black87))),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
