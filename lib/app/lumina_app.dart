import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controllers/navigation_controller.dart';
import '../models/app_user.dart';
import '../screens/auth/login_preview_screen.dart';
import '../screens/shell/app_shell.dart';
import '../services/auth_service.dart';
import '../services/user_profile_service.dart';
import 'app_theme.dart';

class LuminaApp extends StatelessWidget {
  const LuminaApp({
    super.key,
    required this.navigationController,
    this.authStateChanges,
    this.userProfileStream,
  });

  final NavigationController navigationController;
  final Stream<User?>? authStateChanges;
  final Stream<AppUser?> Function(String uid)? userProfileStream;

  @override
  Widget build(BuildContext context) {
    final authStream = authStateChanges ?? AuthService().authStateChanges;

    return MaterialApp(
      title: 'Lumina',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: StreamBuilder<User?>(
        stream: authStream,
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const _AuthBootstrapScreen();
          }

          final user = authSnapshot.data;

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

          final profileStream =
              userProfileStream?.call(user.uid) ??
              UserProfileService().watchUserProfile(user.uid);

          return StreamBuilder<AppUser?>(
            stream: profileStream,
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const _AuthBootstrapScreen();
              }

              final profile = profileSnapshot.data;

              if (profile != null) {
                navigationController.setAuthenticatedUser(profile);
              } else if (!navigationController.isPreviewSessionActive) {
                navigationController.startPreviewFromAuth();
              }

              return AppShell(controller: navigationController);
            },
          );
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
