import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/ui_utils.dart';
import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../../../core/widgets/edu_empty_state.dart';
import '../../../../core/widgets/edu_search_field.dart';
import '../../../../theme/app_theme.dart';
import '../../data/student_mock_data.dart';
import '../../data/resource_repository.dart';

const _allCategories = [
  'All',
  'Textbooks',
  'Past Papers',
  'Notes',
  'Quizzes',
  'Study Guides',
];

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> with SingleTickerProviderStateMixin {
  String _query = '';
  String _activeCategory = 'All';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<StudentResource> _getFiltered(List<StudentResource> resources) {
    return resources.where((r) {
      final matchesQuery = _query.isEmpty ||
          r.title.toLowerCase().contains(_query.toLowerCase()) ||
          r.subject.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory = _activeCategory == 'All' ||
          r.type.toLowerCase().contains(
                _activeCategory.toLowerCase().replaceAll(' ', '_'),
              ) ||
          r.type.toLowerCase() ==
              _activeCategory.toLowerCase().replaceAll(' ', ' ');
      return matchesQuery && matchesCategory;
    }).toList();
  }

  List<StudentResource> _getSavedFiltered(List<StudentResource> filtered) {
    return filtered.where((r) => r.isSaved).toList();
  }

  (Color, Color, String) _offlineConfig(BuildContext context, String status) {
    final theme = Theme.of(context);
    return switch (status) {
      'available'         => (theme.colorScheme.secondaryContainer, theme.colorScheme.onSecondaryContainer, 'Offline Ready'),
      'download_available'=> (theme.colorScheme.surfaceContainerHigh, theme.colorScheme.onSurface, 'Download'),
      'downloading'       => (theme.colorScheme.primaryContainer, theme.colorScheme.onPrimaryContainer, 'Downloading…'),
      'pending_sync'      => (theme.colorScheme.tertiaryContainer, theme.colorScheme.onTertiaryContainer, 'Pending Sync'),
      'unavailable'       => (theme.colorScheme.errorContainer, theme.colorScheme.onErrorContainer, 'Online Only'),
      _                   => (theme.colorScheme.surfaceContainer, theme.colorScheme.onSurfaceVariant, status),
    };
  }

  IconData _typeIcon(String type) {
    return switch (type.toLowerCase()) {
      'textbook'   => Icons.menu_book_rounded,
      'past paper' => Icons.assignment_rounded,
      'notes'      => Icons.notes_rounded,
      'quiz'       => Icons.quiz_rounded,
      'study guide'=> Icons.lightbulb_rounded,
      _            => Icons.insert_drive_file_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final resourcesAsync = ref.watch(resourcesProvider);
    final resources = resourcesAsync.valueOrNull ?? studentResources;

    final filtered = _getFiltered(resources);
    final savedFiltered = _getSavedFiltered(filtered);
    final featured = filtered.where((r) => r.isFeatured).toList();
    final others = filtered.where((r) => !r.isFeatured).toList();

    final downloaded = resources
        .where((r) => r.offlineStatus == 'available')
        .length;
    final savedCount = resources.where((r) => r.isSaved).length;
    final theme = Theme.of(context);

    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats row
                Row(
                  children: [
                    _StatPill(
                      value: '${resources.length}+',
                      label: 'Resources',
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 24,
                      color: theme.colorScheme.outline.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 8),
                    _StatPill(value: '$downloaded', label: 'Downloaded'),
                  ],
                ),
                const SizedBox(height: 12),
                EduSearchField(
                  hintText: 'Search resources…',
                  onChanged: (v) => setState(() => _query = v),
                ),
                const SizedBox(height: 10),
                // Filter chips
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _allCategories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final cat = _allCategories[i];
                      final active = cat == _activeCategory;
                      return GestureDetector(
                        onTap: () => setState(() => _activeCategory = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: active
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: active
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outline.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: active
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // Tabs: All / Saved
                TabBar(
                  controller: _tabController,
                  isScrollable: false,
                  dividerColor: theme.colorScheme.outlineVariant,
                  labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  tabs: [
                    const Tab(text: 'All'),
                    Tab(text: savedCount > 0 ? 'Saved ($savedCount)' : 'Saved'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── ALL tab ──
                filtered.isEmpty
                    ? EduEmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'No resources found',
                        description: 'Try adjusting your search or category filter.',
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        children: [
                          if (featured.isNotEmpty) ...[
                            _SectionLabel(
                              icon: Icons.star_rounded,
                              label: 'Featured Resources',
                            ),
                            const SizedBox(height: 10),
                            ...featured.map(
                              (r) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _ResourceCard(
                                  resource: r,
                                  offlineConfig: _offlineConfig(context, r.offlineStatus),
                                  typeIcon: _typeIcon(r.type),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                          ],
                          if (others.isNotEmpty) ...[
                            _SectionLabel(
                              icon: Icons.book_rounded,
                              label: 'All Resources',
                              count: others.length,
                            ),
                            const SizedBox(height: 10),
                            ...others.map(
                              (r) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _ResourceCard(
                                  resource: r,
                                  offlineConfig: _offlineConfig(context, r.offlineStatus),
                                  typeIcon: _typeIcon(r.type),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                // ── SAVED tab ──
                savedFiltered.isEmpty
                    ? EduEmptyState(
                        icon: Icons.bookmark_outline_rounded,
                        title: 'No saved resources',
                        description: 'Tap the bookmark icon on any resource to save it for quick access.',
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        children: [
                          _SectionLabel(
                            icon: Icons.bookmark_rounded,
                            label: 'Saved Resources',
                            count: savedFiltered.length,
                          ),
                          const SizedBox(height: 10),
                          ...savedFiltered.map(
                            (r) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _ResourceCard(
                                resource: r,
                                offlineConfig: _offlineConfig(context, r.offlineStatus),
                                typeIcon: _typeIcon(r.type),
                              ),
                            ),
                          ),
                        ],
                      ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const WidgetSpan(child: SizedBox(width: 4)),
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.label, this.count});
  final IconData icon;
  final String label;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        if (count != null) ...[
          const Spacer(),
          Text(
            '$count items',
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}

class _ResourceCard extends ConsumerStatefulWidget {
  const _ResourceCard({
    required this.resource,
    required this.offlineConfig,
    required this.typeIcon,
  });

  final StudentResource resource;
  final (Color, Color, String) offlineConfig;
  final IconData typeIcon;

  @override
  ConsumerState<_ResourceCard> createState() => _ResourceCardState();
}

class _ResourceCardState extends ConsumerState<_ResourceCard> {
  bool _isSaving = false;
  bool _isCompleting = false;

  Future<void> _toggleSave() async {
    setState(() => _isSaving = true);
    await ref.read(resourcesProvider.notifier).toggleSaved(widget.resource.id);
    if (mounted) setState(() => _isSaving = false);
  }

  Future<void> _toggleComplete() async {
    setState(() => _isCompleting = true);
    await ref.read(resourcesProvider.notifier).toggleCompleted(widget.resource.id);
    if (mounted) setState(() => _isCompleting = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resource = widget.resource;
    final (bgColor, fgColor, statusLabel) = widget.offlineConfig;
    final typeIcon = widget.typeIcon;
    final isDownloading = resource.offlineStatus == 'downloading';
    final isAvailable = resource.offlineStatus == 'available';
    final canDownload = resource.offlineStatus == 'download_available';
    final isCompleted = resource.status == 'completed';
    final isSaved = resource.isSaved;

    return EduCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: EduSupportTheme.radiusMd,
                ),
                child: Icon(typeIcon, size: 18, color: theme.colorScheme.onSurface),
              ),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (resource.author != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        resource.author!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: EduSupportTheme.radiusLg,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isDownloading)
                      SizedBox(
                        width: 9,
                        height: 9,
                        child: CircularProgressIndicator(
                          value: 0.7,
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                        ),
                      )
                    else
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: fgColor,
                        ),
                      ),
                    const SizedBox(width: 4),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: fgColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            resource.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          // Meta badges row
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              EduBadge(label: resource.subject, tone: EduBadgeTone.info),
              EduBadge(label: resource.grade, tone: EduBadgeTone.neutral),
              EduBadge(label: resource.type, tone: EduBadgeTone.neutral),
              if (resource.fileSize != null)
                EduBadge(label: resource.fileSize!, tone: EduBadgeTone.neutral),
              if (resource.pages != null)
                EduBadge(
                  label: '${resource.pages} pages',
                  tone: EduBadgeTone.neutral,
                ),
            ],
          ),
          if (canDownload || isAvailable) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: EduButton(
                    label: isAvailable ? 'Open Offline' : 'Download',
                    variant: isAvailable
                        ? EduButtonVariant.secondary
                        : EduButtonVariant.outline,
                    size: EduButtonSize.small,
                    leading: Icon(
                      isAvailable ? Icons.open_in_new_rounded : Icons.download_rounded,
                      size: 15,
                    ),
                    onPressed: () => showNotImplementedSnackBar(context),
                  ),
                ),
                const SizedBox(width: 8),
                // Save button
                _isSaving
                    ? const SizedBox(
                        width: 32,
                        height: 32,
                        child: Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))),
                      )
                    : Tooltip(
                        message: isSaved ? 'Remove from saved' : 'Save resource',
                        child: IconButton(
                          icon: Icon(
                            isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                            color: isSaved ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          onPressed: _toggleSave,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          style: IconButton.styleFrom(
                            backgroundColor: isSaved ? theme.colorScheme.primary.withValues(alpha: 0.1) : null,
                            shape: RoundedRectangleBorder(borderRadius: EduSupportTheme.radiusSm),
                          ),
                        ),
                      ),
                if (isAvailable) ...[
                  const SizedBox(width: 4),
                  // Mark Complete button
                  _isCompleting
                      ? const SizedBox(
                          width: 32,
                          height: 32,
                          child: Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))),
                        )
                      : Tooltip(
                          message: isCompleted ? 'Mark as in progress' : 'Mark as complete',
                          child: IconButton(
                            icon: Icon(
                              isCompleted ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                              color: isCompleted ? Colors.green.shade600 : theme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                            onPressed: _toggleComplete,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                            style: IconButton.styleFrom(
                              backgroundColor: isCompleted ? Colors.green.withValues(alpha: 0.1) : null,
                              shape: RoundedRectangleBorder(borderRadius: EduSupportTheme.radiusSm),
                            ),
                          ),
                        ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
