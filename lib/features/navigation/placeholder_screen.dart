import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Text(
          '$title\nComing soon',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18),
        ),
      ),
    );
  }
}
