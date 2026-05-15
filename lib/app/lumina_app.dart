import 'package:flutter/material.dart';

import '../controllers/navigation_controller.dart';
import '../screens/auth/login_preview_screen.dart';
import '../screens/shell/app_shell.dart';
import 'app_theme.dart';

class LuminaApp extends StatelessWidget {
  const LuminaApp({super.key, required this.navigationController});

  final NavigationController navigationController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumina',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: AnimatedBuilder(
        animation: navigationController,
        builder: (context, _) {
          if (!navigationController.isPreviewSessionActive) {
            return LoginPreviewScreen(controller: navigationController);
          }

          return AppShell(controller: navigationController);
        },
      ),
    );
  }
}
