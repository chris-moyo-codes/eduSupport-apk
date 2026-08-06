import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/ui_utils.dart';
import '../../../../core/widgets/edu_avatar.dart';
import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../settings/application/theme_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, this.onOpenDownloads});
  final VoidCallback? onOpenDownloads;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Toggle states matching web profile toggles
  bool _autoDownload = true;
  bool _lowBandwidth = false;
  bool _sessionReminders = true;
  bool _newResources = false;
  bool _examReminders = true;
  bool _reduceMotion = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(authControllerProvider.select((s) => s.user));
    final themeMode = ref.watch(themeControllerProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Identity ──────────────────────────────────────────────────────
              Row(
                children: [
                  EduAvatar(initials: user?.initials ?? '??', size: 64),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Unknown User',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: [
                            EduBadge(
                              label: user?.role.name.toUpperCase() ?? 'STUDENT',
                              tone: EduBadgeTone.info,
                            ),
                            const EduBadge(
                              label: 'Active Learner',
                              tone: EduBadgeTone.success,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // ── Learning Preferences ──────────────────────────────────────────
              _SettingsSection(
                icon: Icons.book_outlined,
                title: 'Learning Preferences',
                children: [
                  _SettingsRow(
                    label: 'Primary Language',
                    description: 'Language used for interface and content',
                    action: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'English',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.chevron_right_rounded,
                            size: 18, color: theme.colorScheme.onSurfaceVariant),
                      ],
                    ),
                  ),
                  _SettingsRow(
                    label: 'Study Goal',
                    description: 'Your daily study target',
                    action: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '30 minutes',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.chevron_right_rounded,
                            size: 18, color: theme.colorScheme.onSurfaceVariant),
                      ],
                    ),
                  ),
                  _SettingsRow(
                    label: 'Exam Reminders',
                    description: 'Notifications before scheduled exams',
                    action: _EduSwitch(
                      value: _examReminders,
                      onChanged: (v) => setState(() => _examReminders = v),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Offline & Storage ─────────────────────────────────────────────
              _SettingsSection(
                icon: Icons.storage_rounded,
                title: 'Offline & Storage',
                children: [
                  _SettingsRow(
                    label: 'Auto-download over Wi-Fi',
                    description: 'Automatically save new resources when connected',
                    action: _EduSwitch(
                      value: _autoDownload,
                      onChanged: (v) => setState(() => _autoDownload = v),
                    ),
                  ),
                  _SettingsRow(
                    label: 'Low bandwidth mode',
                    description: 'Reduce data usage when on mobile data',
                    action: _EduSwitch(
                      value: _lowBandwidth,
                      onChanged: (v) => setState(() => _lowBandwidth = v),
                    ),
                  ),
                  _SettingsRow(
                    label: 'Manage Downloads',
                    description: 'View and remove offline content',
                    action: EduButton(
                      label: 'Open',
                      variant: EduButtonVariant.ghost,
                      size: EduButtonSize.small,
                      onPressed: widget.onOpenDownloads,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Notifications ─────────────────────────────────────────────────
              _SettingsSection(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                children: [
                  _SettingsRow(
                    label: 'Session reminders',
                    description: 'Remind me 15 minutes before a session',
                    action: _EduSwitch(
                      value: _sessionReminders,
                      onChanged: (v) => setState(() => _sessionReminders = v),
                    ),
                  ),
                  _SettingsRow(
                    label: 'New resources',
                    description: 'When new content is added to my subjects',
                    action: _EduSwitch(
                      value: _newResources,
                      onChanged: (v) => setState(() => _newResources = v),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Appearance ────────────────────────────────────────────────────
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
                  _SettingsRow(
                    label: 'Reduce motion',
                    description: 'Minimise animations throughout the app',
                    action: _EduSwitch(
                      value: _reduceMotion,
                      onChanged: (v) => setState(() => _reduceMotion = v),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Account ───────────────────────────────────────────────────────
              _SettingsSection(
                icon: Icons.shield_outlined,
                title: 'Account',
                children: [
                  _SettingsRow(
                    label: 'Change password',
                    action: EduButton(
                      label: 'Update',
                      variant: EduButtonVariant.secondary,
                      size: EduButtonSize.small,
                      onPressed: () => showNotImplementedSnackBar(context),
                    ),
                  ),
                  _SettingsRow(
                    label: 'Sign out of all devices',
                    action: EduButton(
                      label: 'Sign out',
                      variant: EduButtonVariant.secondary,
                      size: EduButtonSize.small,
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        ref.read(authControllerProvider.notifier).logout();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Sign Out ──────────────────────────────────────────────────────
              EduButton(
                fullWidth: true,
                variant: EduButtonVariant.destructive,
                label: 'Sign Out',
                leading: const Icon(Icons.logout_rounded, size: 20),
                onPressed: () async {
                  final confirm = await showLogoutConfirmationDialog(context);
                  if (confirm == true && context.mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    ref.read(authControllerProvider.notifier).logout();
                  }
                },
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
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
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
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
