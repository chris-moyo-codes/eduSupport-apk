import 'package:flutter/material.dart';

import '../../../../core/widgets/edu_card.dart';
import '../../../../core/widgets/edu_empty_state.dart';
import '../../../../theme/app_theme.dart';
import '../../data/student_mock_data.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final downloaded =
        studentResources.where((r) => r.offlineStatus == 'available').toList();
    final downloading =
        studentResources.where((r) => r.offlineStatus == 'downloading').toList();
    final pending =
        studentResources.where((r) => r.offlineStatus == 'pending_sync').toList();
    final unavailable =
        studentResources.where((r) => r.offlineStatus == 'unavailable').toList();

    // Mock storage: 237 MB used of 2048 MB total
    const usedMb = 237.0;
    const totalMb = 2048.0;
    final storageFraction = usedMb / totalMb;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Offline Library',
          style: theme.textTheme.titleMedium?.copyWith(fontSize: 17),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Page intro ────────────────────────────────────────────────
              Text(
                'Manage content downloaded for study without internet.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),

              // ── Storage bar ───────────────────────────────────────────────
              EduCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.storage_rounded,
                            size: 16, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Text(
                          'Storage Used',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${usedMb.toInt()} MB / ${(totalMb / 1024).toStringAsFixed(0)} GB',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: EduSupportTheme.radiusMd,
                      child: LinearProgressIndicator(
                        value: storageFraction,
                        minHeight: 8,
                        backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Downloading ───────────────────────────────────────────────
              if (downloading.isNotEmpty) ...[
                Row(
                  children: [
                    _PulseDot(color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Downloading',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...downloading.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _DownloadItem(resource: r),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Pending Sync ──────────────────────────────────────────────
              if (pending.isNotEmpty) ...[
                Text(
                  'Pending Sync',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Local changes waiting to sync when back online.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                ...pending.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _DownloadItem(resource: r),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Available Offline ─────────────────────────────────────────
              Row(
                children: [
                  Icon(Icons.folder_rounded,
                      size: 16, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(
                    'Available Offline',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(${downloaded.length})',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  if (downloaded.isNotEmpty)
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: theme.colorScheme.error,
                      ),
                      child: const Text(
                        'Remove all',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (downloaded.isEmpty)
                EduEmptyState(
                  icon: Icons.folder_rounded,
                  title: 'Nothing downloaded yet',
                  description:
                      'Visit the Library and download resources to study them offline.',
                )
              else
                ...downloaded.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _DownloadItem(resource: r),
                  ),
                ),

              const SizedBox(height: 20),

              // ── Unavailable Offline ───────────────────────────────────────
              if (unavailable.isNotEmpty) ...[
                Text(
                  'Unavailable Offline',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'These resources require an internet connection.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                ...unavailable.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _DownloadItem(resource: r),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot({required this.color});
  final Color color;

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) => Opacity(
        opacity: 0.4 + (_controller.value * 0.6),
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}

class _DownloadItem extends StatelessWidget {
  const _DownloadItem({required this.resource});
  final StudentResource resource;

  IconData get _statusIcon {
    return switch (resource.offlineStatus) {
      'available'          => Icons.download_done_rounded,
      'download_available' => Icons.download_rounded,
      'downloading'        => Icons.sync_rounded,
      'pending_sync'       => Icons.sync_problem_rounded,
      'unavailable'        => Icons.cloud_off_rounded,
      _                    => Icons.insert_drive_file_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _resolveStatusColor(theme.colorScheme);

    return EduCard(
      child: Row(
        children: [
          Icon(_statusIcon, size: 20, color: statusColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resource.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${resource.subject} · ${resource.type}'
                  '${resource.fileSize != null ? ' · ${resource.fileSize}' : ''}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (resource.offlineStatus == 'downloading')
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                value: 0.7,
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              ),
            ),
          if (resource.offlineStatus == 'available')
            IconButton(
              icon: Icon(Icons.delete_outline_rounded,
                  size: 18, color: theme.colorScheme.outline),
              onPressed: () {},
              tooltip: 'Remove',
            ),
        ],
      ),
    );
  }

  Color _resolveStatusColor(ColorScheme cs) {
    return switch (resource.offlineStatus) {
      'available'          => cs.primary,
      'download_available' => cs.secondary,
      'downloading'        => cs.primary,
      'pending_sync'       => cs.secondary,
      'unavailable'        => cs.error,
      _                    => cs.onSurfaceVariant,
    };
  }
}
