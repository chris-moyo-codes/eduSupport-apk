import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_button.dart';
import '../../../settings/application/theme_controller.dart';

class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  ConsumerState<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {
  bool _maintenanceMode = false;
  bool _registrationOpen = true;
  bool _enforce2FA = false;
  bool _emailAlerts = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeControllerProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('System Settings'),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Platform Configuration ──────────────────────────────────────
              _SettingsSection(
                icon: Icons.settings_applications_outlined,
                title: 'Platform Configuration',
                children: [
                  _SettingsRow(
                    label: 'Maintenance Mode',
                    description: 'Restrict access to administrators only',
                    action: _EduSwitch(
                      value: _maintenanceMode,
                      onChanged: (v) => setState(() => _maintenanceMode = v),
                    ),
                  ),
                  _SettingsRow(
                    label: 'Open Registration',
                    description: 'Allow new students and tutors to sign up',
                    action: _EduSwitch(
                      value: _registrationOpen,
                      onChanged: (v) => setState(() => _registrationOpen = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Security & Access ───────────────────────────────────────────
              _SettingsSection(
                icon: Icons.security_outlined,
                title: 'Security & Access',
                children: [
                  _SettingsRow(
                    label: 'Enforce 2FA',
                    description: 'Require two-factor authentication for tutors',
                    action: _EduSwitch(
                      value: _enforce2FA,
                      onChanged: (v) => setState(() => _enforce2FA = v),
                    ),
                  ),
                  _SettingsRow(
                    label: 'Role Permissions',
                    description: 'Manage access levels across the platform',
                    action: EduButton(
                      label: 'Manage',
                      variant: EduButtonVariant.ghost,
                      size: EduButtonSize.small,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Notifications & Alerts ──────────────────────────────────────
              _SettingsSection(
                icon: Icons.campaign_outlined,
                title: 'Notifications',
                children: [
                  _SettingsRow(
                    label: 'Admin Email Alerts',
                    description: 'Receive emails for critical system alerts',
                    action: _EduSwitch(
                      value: _emailAlerts,
                      onChanged: (v) => setState(() => _emailAlerts = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Appearance ──────────────────────────────────────────────────
              _SettingsSection(
                icon: Icons.dark_mode_outlined,
                title: 'Appearance',
                children: [
                  _SettingsRow(
                    label: 'Theme',
                    description: 'Choose your preferred colour scheme',
                    action: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: EduThemeMode.values.map((t) {
                        final active = t == themeMode;
                        return GestureDetector(
                          onTap: () {
                            ref.read(themeControllerProvider.notifier).setTheme(t);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(left: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: active
                                  ? theme.colorScheme.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: active
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.outlineVariant,
                              ),
                            ),
                            child: Text(
                              t.name[0].toUpperCase() + t.name.substring(1),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: active
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Reusable Profile Widgets ──────────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.label,
    this.description,
    this.action,
  });

  final String label;
  final String? description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 12),
            action!,
          ],
        ],
      ),
    );
  }
}

class _EduSwitch extends StatelessWidget {
  const _EduSwitch({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 42,
        height: 24,
        decoration: BoxDecoration(
          color: value ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18,
            height: 18,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
