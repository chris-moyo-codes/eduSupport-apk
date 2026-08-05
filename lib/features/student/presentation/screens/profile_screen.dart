import 'package:flutter/material.dart';

import '../../../../core/widgets/edu_avatar.dart';
import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.onOpenDownloads});
  final VoidCallback? onOpenDownloads;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Toggle states matching web profile toggles
  bool _autoDownload = true;
  bool _lowBandwidth = false;
  bool _sessionReminders = true;
  bool _newResources = false;
  bool _examReminders = true;
  bool _reduceMotion = false;
  String _theme = 'System';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Identity Card ─────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE4E2DC), width: 1.5),
              ),
              child: Row(
                children: [
                  const EduAvatar(initials: 'SD', size: 64),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Student Demo',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A202C),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'student@edusupport.local',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Wrap(
                          spacing: 6,
                          children: [
                            EduBadge(label: 'Student', tone: EduBadgeTone.info),
                            EduBadge(
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
            ),

            const SizedBox(height: 20),

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
                      const Text(
                        'English',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right_rounded,
                          size: 18, color: Color(0xFFA0AEC0)),
                    ],
                  ),
                ),
                _SettingsRow(
                  label: 'Study Goal',
                  description: 'Your daily study target',
                  action: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '30 minutes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right_rounded,
                          size: 18, color: Color(0xFFA0AEC0)),
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

            const SizedBox(height: 14),

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

            const SizedBox(height: 14),

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

            const SizedBox(height: 14),

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
                    children: ['Light', 'Dark', 'System'].map((t) {
                      final active = t == _theme;
                      return GestureDetector(
                        onTap: () => setState(() => _theme = t),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: active
                                ? const Color(0xFF212B36)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: active
                                  ? const Color(0xFF212B36)
                                  : const Color(0xFFE4E2DC),
                            ),
                          ),
                          child: Text(
                            t,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? Colors.white
                                  : const Color(0xFF718096),
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

            const SizedBox(height: 14),

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
                    onPressed: () {},
                  ),
                ),
                _SettingsRow(
                  label: 'Sign out of all devices',
                  action: EduButton(
                    label: 'Sign out',
                    variant: EduButtonVariant.secondary,
                    size: EduButtonSize.small,
                    onPressed: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Sign Out ──────────────────────────────────────────────────────
            EduButton(
              label: 'Sign Out',
              variant: EduButtonVariant.ghost,
              leading: const Icon(Icons.logout_rounded, size: 16),
              fullWidth: true,
              onPressed: () {},
            ),
          ],
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
    return EduCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 16, color: const Color(0xFF1A202C)),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A202C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A202C),
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF718096),
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
          color: value ? const Color(0xFF212B36) : const Color(0xFFC8C5BC),
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
