import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controllers/navigation_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../models/app_user.dart';
import '../../services/auth_service.dart';

enum _AuthMode { signIn, register, resetPassword, verifyEmail }

class LoginPreviewScreen extends StatefulWidget {
  const LoginPreviewScreen({super.key, required this.controller});

  final NavigationController controller;

  @override
  State<LoginPreviewScreen> createState() => _LoginPreviewScreenState();
}

class _LoginPreviewScreenState extends State<LoginPreviewScreen> {
  AuthService? _authService;

  AuthService get authService {
    return _authService ??= AuthService();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController(
    text: 'Lumina',
  );
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  _AuthMode _mode = _AuthMode.signIn;
  bool _loading = false;
  bool _acceptedTerms = false;
  String? _message;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _organizationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    await _runAuthAction(() async {
      await authService.signInWithEmailPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      widget.controller.startPreview(AppRole.employee);
    });
  }

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }

    if (!_acceptedTerms) {
      setState(() => _error = 'Please accept the terms before continuing.');
      return;
    }

    await _runAuthAction(() async {
      await authService.registerWithEmailPassword(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        organizationName: _organizationController.text,
      );

      setState(() {
        _mode = _AuthMode.verifyEmail;
        _message = 'Verification email sent.';
      });
    });
  }

  Future<void> _sendResetEmail() async {
    await _runAuthAction(() async {
      await authService.sendPasswordResetEmail(_emailController.text);

      setState(() {
        _message = 'Password reset link sent to your email.';
        _mode = _AuthMode.signIn;
      });
    });
  }

  Future<void> _resendVerificationEmail() async {
    await _runAuthAction(() async {
      await authService.resendVerificationEmail();

      setState(() {
        _message = 'Verification email sent again.';
      });
    });
  }

  Future<void> _checkVerification() async {
    await _runAuthAction(() async {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();

      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser == null || !refreshedUser.emailVerified) {
        throw const AuthFailure('Email is not verified yet.');
      }

      widget.controller.startPreview(AppRole.employee);
    });
  }

  Future<void> _runAuthAction(Future<void> Function() action) async {
    setState(() {
      _loading = true;
      _error = null;
      _message = null;
    });

    try {
      await action();
    } on AuthFailure catch (error) {
      setState(() => _error = error.message);

      if (error.message.toLowerCase().contains('verify')) {
        setState(() => _mode = _AuthMode.verifyEmail);
      }
    } catch (_) {
      setState(() => _error = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _switchMode(_AuthMode mode) {
    setState(() {
      _mode = mode;
      _error = null;
      _message = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 920;

    return Scaffold(
      backgroundColor: const Color(0xFF090D12),
      body: Stack(
        children: [
          const _AuthBackdrop(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: wide ? 40 : 22,
                  vertical: 28,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: wide ? 1080 : 560),
                  child: wide
                      ? Row(
                          children: [
                            const Expanded(child: _BrandPanel()),
                            const SizedBox(width: 48),
                            SizedBox(width: 460, child: _authCard()),
                          ],
                        )
                      : _authCard(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _authCard() {
    return _AuthCard(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: _loading
            ? const _LoadingPanel()
            : switch (_mode) {
                _AuthMode.signIn => _SignInPanel(
                  key: const ValueKey('sign-in'),
                  emailController: _emailController,
                  passwordController: _passwordController,
                  error: _error,
                  message: _message,
                  onSignIn: _signIn,
                  onCreateAccount: () => _switchMode(_AuthMode.register),
                  onForgotPassword: () => _switchMode(_AuthMode.resetPassword),
                ),
                _AuthMode.register => _RegisterPanel(
                  key: const ValueKey('register'),
                  nameController: _nameController,
                  organizationController: _organizationController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  acceptedTerms: _acceptedTerms,
                  error: _error,
                  message: _message,
                  onAcceptedTermsChanged: (value) {
                    setState(() => _acceptedTerms = value ?? false);
                  },
                  onRegister: _register,
                  onSignIn: () => _switchMode(_AuthMode.signIn),
                ),
                _AuthMode.resetPassword => _ResetPasswordPanel(
                  key: const ValueKey('reset'),
                  emailController: _emailController,
                  error: _error,
                  message: _message,
                  onSendReset: _sendResetEmail,
                  onBack: () => _switchMode(_AuthMode.signIn),
                ),
                _AuthMode.verifyEmail => _VerifyEmailPanel(
                  key: const ValueKey('verify'),
                  email: _emailController.text.trim().toLowerCase(),
                  error: _error,
                  message: _message,
                  onResend: _resendVerificationEmail,
                  onCheckVerification: _checkVerification,
                  onBack: () => _switchMode(_AuthMode.signIn),
                ),
              },
      ),
    );
  }
}

class _AuthBackdrop extends StatelessWidget {
  const _AuthBackdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.2, -0.35),
          radius: 1.0,
          colors: [Color(0xFF15213A), Color(0xFF090D12)],
        ),
      ),
      child: CustomPaint(
        painter: _DotGridPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.035);

    for (double x = 28; x < size.width; x += 38) {
      for (double y = 28; y < size.height; y += 38) {
        canvas.drawCircle(Offset(x, y), 1.1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LogoMark(size: 86),
        SizedBox(height: 32),
        Text(
          'Lumina',
          style: TextStyle(
            color: Color(0xFFF4F7FB),
            fontSize: 58,
            height: 1,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 18),
        Text(
          'Enterprise performance intelligence',
          style: TextStyle(
            color: Color(0xFFB9C1D1),
            fontSize: 18,
            height: 1.5,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF11161D).withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF323A49)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4E8DFF).withValues(alpha: 0.14),
            blurRadius: 38,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.42),
            blurRadius: 30,
            offset: const Offset(0, 22),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SignInPanel extends StatelessWidget {
  const _SignInPanel({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.error,
    required this.message,
    required this.onSignIn,
    required this.onCreateAccount,
    required this.onForgotPassword,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? error;
  final String? message;
  final VoidCallback onSignIn;
  final VoidCallback onCreateAccount;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _MobileLogoHeader(),
        const Text(
          'Welcome back',
          style: TextStyle(
            color: Color(0xFFF4F7FB),
            fontSize: 34,
            height: 1.1,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to your Lumina workspace.',
          style: TextStyle(color: Color(0xFFB7BFCE), fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 28),
        _AuthField(
          label: 'Corporate email',
          controller: emailController,
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 18),
        _AuthField(
          label: 'Password',
          controller: passwordController,
          icon: Icons.lock_outline_rounded,
          obscureText: true,
          trailing: TextButton(
            onPressed: onForgotPassword,
            child: const Text('Forgot password?'),
          ),
        ),
        const SizedBox(height: 22),
        _PrimaryButton(label: 'Continue to workspace', onPressed: onSignIn),
        const SizedBox(height: 18),
        _InlineMessage(error: error, message: message),
        const SizedBox(height: 20),
        _ModeSwitch(
          text: 'New to Lumina?',
          action: 'Create account',
          onPressed: onCreateAccount,
        ),
      ],
    );
  }
}

class _RegisterPanel extends StatelessWidget {
  const _RegisterPanel({
    super.key,
    required this.nameController,
    required this.organizationController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.acceptedTerms,
    required this.error,
    required this.message,
    required this.onAcceptedTermsChanged,
    required this.onRegister,
    required this.onSignIn,
  });

  final TextEditingController nameController;
  final TextEditingController organizationController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool acceptedTerms;
  final String? error;
  final String? message;
  final ValueChanged<bool?> onAcceptedTermsChanged;
  final VoidCallback onRegister;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Create an account',
          style: TextStyle(
            color: Color(0xFFF4F7FB),
            fontSize: 32,
            height: 1.1,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Enter your professional details to get started.',
          style: TextStyle(color: Color(0xFFB7BFCE), fontSize: 15, height: 1.5),
        ),
        const SizedBox(height: 26),
        _AuthField(
          label: 'Full name',
          controller: nameController,
          icon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 16),
        _AuthField(
          label: 'Organization',
          controller: organizationController,
          icon: Icons.apartment_rounded,
        ),
        const SizedBox(height: 16),
        _AuthField(
          label: 'Corporate email',
          controller: emailController,
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _AuthField(
          label: 'Password',
          controller: passwordController,
          icon: Icons.lock_outline_rounded,
          obscureText: true,
        ),
        const SizedBox(height: 16),
        _AuthField(
          label: 'Confirm password',
          controller: confirmPasswordController,
          icon: Icons.verified_user_outlined,
          obscureText: true,
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(value: acceptedTerms, onChanged: onAcceptedTermsChanged),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'I agree to the Terms of Service and Privacy Policy.',
                  style: TextStyle(color: Color(0xFFCED5E2), height: 1.4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _PrimaryButton(label: 'Create account', onPressed: onRegister),
        const SizedBox(height: 18),
        _InlineMessage(error: error, message: message),
        const SizedBox(height: 20),
        _ModeSwitch(
          text: 'Already have an account?',
          action: 'Sign in',
          onPressed: onSignIn,
        ),
      ],
    );
  }
}

class _ResetPasswordPanel extends StatelessWidget {
  const _ResetPasswordPanel({
    super.key,
    required this.emailController,
    required this.error,
    required this.message,
    required this.onSendReset,
    required this.onBack,
  });

  final TextEditingController emailController;
  final String? error;
  final String? message;
  final VoidCallback onSendReset;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _LogoMark(size: 64),
        const SizedBox(height: 28),
        const Text(
          'Reset password',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFF4F7FB),
            fontSize: 32,
            height: 1.1,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Enter your email and we will send a secure reset link.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFB7BFCE), fontSize: 15, height: 1.5),
        ),
        const SizedBox(height: 28),
        _AuthField(
          label: 'Corporate email',
          controller: emailController,
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 22),
        _PrimaryButton(label: 'Send reset link', onPressed: onSendReset),
        const SizedBox(height: 18),
        _InlineMessage(error: error, message: message),
        const SizedBox(height: 18),
        TextButton(onPressed: onBack, child: const Text('Back to sign in')),
      ],
    );
  }
}

class _VerifyEmailPanel extends StatelessWidget {
  const _VerifyEmailPanel({
    super.key,
    required this.email,
    required this.error,
    required this.message,
    required this.onResend,
    required this.onCheckVerification,
    required this.onBack,
  });

  final String email;
  final String? error;
  final String? message;
  final VoidCallback onResend;
  final VoidCallback onCheckVerification;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _MailIllustration(),
        const SizedBox(height: 28),
        const Text(
          'Check your email',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFF4F7FB),
            fontSize: 34,
            height: 1.1,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        Text.rich(
          TextSpan(
            text: "We've sent a verification link to\n",
            children: [
              TextSpan(
                text: email.isEmpty ? 'your email address' : email,
                style: const TextStyle(
                  color: Color(0xFFAFC8FF),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFC9D1DF),
            fontSize: 16,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 22),
        _PrimaryButton(
          label: 'I verified, continue',
          onPressed: onCheckVerification,
        ),
        const SizedBox(height: 12),
        _SecondaryButton(label: 'Resend email', onPressed: onResend),
        const SizedBox(height: 16),
        _InlineMessage(error: error, message: message),
        const SizedBox(height: 16),
        TextButton(onPressed: onBack, child: const Text('Back to sign in')),
      ],
    );
  }
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SkeletonBox(width: 82, height: 82, centered: true),
        SizedBox(height: 30),
        _SkeletonBox(width: 260, height: 34, centered: true),
        SizedBox(height: 14),
        _SkeletonBox(width: 340, height: 18, centered: true),
        SizedBox(height: 34),
        _SkeletonBox(width: double.infinity, height: 54),
        SizedBox(height: 16),
        _SkeletonBox(width: double.infinity, height: 54),
        SizedBox(height: 24),
        _SkeletonBox(width: double.infinity, height: 56),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    this.centered = false,
  });

  final double width;
  final double height;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF252C38),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return centered ? Center(child: box) : box;
  }
}

class _MobileLogoHeader extends StatelessWidget {
  const _MobileLogoHeader();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width >= 920) {
      return const SizedBox.shrink();
    }

    return const Column(
      children: [
        _LogoMark(size: 58),
        SizedBox(height: 18),
        Text(
          'Lumina',
          style: TextStyle(
            color: Color(0xFFEFF4FF),
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 28),
      ],
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFAFC8FF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4B86FF).withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Icon(
        Icons.auto_awesome_rounded,
        color: const Color(0xFF09235A),
        size: size * 0.46,
      ),
    );
  }
}

class _MailIllustration extends StatelessWidget {
  const _MailIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 190,
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFF171C23),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF3C4658)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A86FF).withValues(alpha: 0.26),
              blurRadius: 42,
            ),
          ],
        ),
        child: const Icon(
          Icons.mark_email_unread_outlined,
          color: Color(0xFFAFC8FF),
          size: 70,
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.trailing,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFC9D0DC),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: const TextStyle(color: Color(0xFFEFF3FA), fontSize: 16),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF9AA4B5)),
            filled: true,
            fillColor: const Color(0xFF171C23),
            hintStyle: const TextStyle(color: Color(0xFF697285)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF3B4556)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFAFC8FF),
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFAFC8FF),
          foregroundColor: const Color(0xFF08245A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        child: Text(label),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFEFF4FF),
          side: const BorderSide(color: Color(0xFF3B4556)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        child: Text(label),
      ),
    );
  }
}

class _InlineMessage extends StatelessWidget {
  const _InlineMessage({required this.error, required this.message});

  final String? error;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final text = error ?? message;

    if (text == null) {
      return const SizedBox.shrink();
    }

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: error == null ? AppColors.success : AppColors.danger,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({
    required this.text,
    required this.action,
    required this.onPressed,
  });

  final String text;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(text, style: const TextStyle(color: Color(0xFFB7BFCE))),
        TextButton(onPressed: onPressed, child: Text(action)),
      ],
    );
  }
}
