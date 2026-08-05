import 'package:flutter/material.dart';

import '../../../../core/widgets/edu_card.dart';
import '../../../../core/widgets/edu_empty_state.dart';
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
      backgroundColor: const Color(0xFFF0F0EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Offline Library',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A202C),
          ),
        ),
        leading: const BackButton(color: Color(0xFF1A202C)),
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
                        const Icon(Icons.storage_rounded,
                            size: 16, color: Color(0xFF718096)),
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
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: storageFraction,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFE4E2DC),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF212B36)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Downloading ───────────────────────────────────────────────
              if (downloading.isNotEmpty) ...[
                _SectionHeader(
                  child: Row(
                    children: [
                      _PulseDot(color: const Color(0xFF212B36)),
                      const SizedBox(width: 6),
                      const Text(
                        'Downloading',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                    ],
                  ),
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
                const _SectionHeader(
                  child: Text(
                    'Pending Sync',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A202C),
                    ),
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
                  const Icon(Icons.folder_rounded,
                      size: 16, color: Color(0xFF718096)),
                  const SizedBox(width: 6),
                  Text(
                    'Available Offline',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A202C),
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
                        foregroundColor: const Color(0xFFC53030),
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
                const Text(
                  'Unavailable Offline',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFC53030),
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
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

  Color get _statusColor {
    return switch (resource.offlineStatus) {
      'available'          => const Color(0xFF38A169),
      'download_available' => const Color(0xFF2B6CB0),
      'downloading'        => const Color(0xFF2C7A7B),
      'pending_sync'       => const Color(0xFFD69E2E),
      'unavailable'        => const Color(0xFFC53030),
      _                    => const Color(0xFF718096),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return EduCard(
      child: Row(
        children: [
          Icon(_statusIcon, size: 20, color: _statusColor),
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
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                value: 0.7,
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xFF2C7A7B)),
              ),
            ),
          if (resource.offlineStatus == 'available')
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  size: 18, color: Color(0xFFA0AEC0)),
              onPressed: () {},
              tooltip: 'Remove',
            ),
        ],
      ),
    );
  }
}
