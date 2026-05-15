import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controllers/navigation_controller.dart';
import '../screens/auth/login_preview_screen.dart';
import '../screens/shell/app_shell.dart';
import '../services/auth_service.dart';
import 'app_theme.dart';

class LuminaApp extends StatelessWidget {
  const LuminaApp({super.key, required this.navigationController});

  final NavigationController navigationController;

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return MaterialApp(
      title: 'Lumina',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: StreamBuilder<User?>(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _AuthBootstrapScreen();
          }

          final user = snapshot.data;

          if (user == null) {
            return LoginPreviewScreen(controller: navigationController);
          }

          if (!user.emailVerified) {
            return LoginPreviewScreen(
              controller: navigationController,
              initialMode: AuthScreenMode.verifyEmail,
              initialEmail: user.email ?? '',
            );
          }

          if (!navigationController.isPreviewSessionActive) {
            navigationController.startPreviewFromAuth();
          }

          return AppShell(controller: navigationController);
        },
      ),
    );
  }
}

class _AuthBootstrapScreen extends StatelessWidget {
  const _AuthBootstrapScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D12),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _BootstrapLogo(),
              SizedBox(height: 28),
              LinearProgressIndicator(
                minHeight: 4,
                backgroundColor: Color(0xFF252C38),
                color: Color(0xFFAFC8FF),
              ),
              SizedBox(height: 20),
              Text(
                'INITIALIZING WORKSPACE',
                style: TextStyle(
                  color: Color(0xFF9DA7B8),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BootstrapLogo extends StatelessWidget {
  const _BootstrapLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      height: 86,
      decoration: BoxDecoration(
        color: const Color(0xFF171C23),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3B4556)),
      ),
      child: const Icon(
        Icons.auto_awesome_rounded,
        color: Color(0xFFAFC8FF),
        size: 42,
      ),
    );
  }
}
