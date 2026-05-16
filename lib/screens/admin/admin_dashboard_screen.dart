import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/app_user.dart';
import '../../services/admin_seed_service.dart';
import '../../widgets/common/section_panel.dart';
import '../../widgets/layout/page_header.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key, required this.user});

  final AppUser user;

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminSeedService _seedService = AdminSeedService();

  bool _loading = false;
  String? _message;
  String? _error;

  Future<void> _seedWorkspace() async {
    setState(() {
      _loading = true;
      _message = null;
      _error = null;
    });

    try {
      await _seedService.ensureWorkspaceSeed(
        organizationId: widget.user.organizationId,
        organizationName: widget.user.organizationName,
        requestedBy: FirebaseAuth.instance.currentUser?.uid ?? widget.user.id,
      );

      setState(() {
        _message = 'Workspace setup completed.';
      });
    } catch (_) {
      setState(() {
        _error = 'Could not complete workspace setup. Check permissions.';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSeed = widget.user.role == AppRole.admin;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          title: 'Admin Console',
          subtitle:
              'Configure your company workspace and prepare Lumina for real data.',
        ),
        const SizedBox(height: 22),
        SectionPanel(
          title: 'Workspace setup',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.organizationName,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create base configuration, the first performance cycle, and starter departments. This is safe to run more than once.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: canSeed && !_loading ? _seedWorkspace : null,
                icon: _loading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_fix_high_rounded),
                label: Text(
                  _loading ? 'Setting up...' : 'Create base workspace',
                ),
              ),
              if (!canSeed) ...[
                const SizedBox(height: 12),
                const Text(
                  'Only Admin users can run workspace setup.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ],
              if (_message != null) ...[
                const SizedBox(height: 12),
                Text(
                  _message!,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: const TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
