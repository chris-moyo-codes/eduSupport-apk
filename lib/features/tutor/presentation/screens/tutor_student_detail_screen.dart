import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/ui_utils.dart';
import '../../../../core/widgets/edu_avatar.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../../../core/widgets/edu_section_header.dart';
import '../../../../core/widgets/edu_text_field.dart';
import '../../../../core/widgets/report_bottom_sheet.dart';
import '../../../../theme/app_theme.dart';
import '../../data/tutor_mock_data.dart';

// Local provider to mock saving notes per student ID
final tutorNotesProvider = StateProvider.family<String, String>((ref, id) {
  return '';
});

class TutorStudentDetailScreen extends ConsumerStatefulWidget {
  const TutorStudentDetailScreen({super.key, required this.student});

  final TutorStudent student;

  @override
  ConsumerState<TutorStudentDetailScreen> createState() => _TutorStudentDetailScreenState();
}

class _TutorStudentDetailScreenState extends ConsumerState<TutorStudentDetailScreen> {
  bool _isEditingNotes = false;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final student = widget.student;
    
    // Sync notes state
    final savedNotes = ref.watch(tutorNotesProvider(student.id));
    if (!_isEditingNotes && _notesController.text.isEmpty && savedNotes.isNotEmpty) {
      _notesController.text = savedNotes;
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Student Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.report_gmailerrorred_rounded, color: colorScheme.error),
            tooltip: 'Report Student',
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => ReportBottomSheet(
                  reportTargetName: student.name,
                  reportTargetRole: 'student',
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Identity
            Center(
              child: Column(
                children: [
                  EduAvatar(initials: student.initials, size: 80),
                  const SizedBox(height: 16),
                  Text(
                    student.name,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${student.grade} • ${student.subject}',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Progress Card
            const EduSectionHeader(title: 'Overall Progress'),
            const SizedBox(height: 12),
            EduCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mastery Score',
                        style: textTheme.titleMedium,
                      ),
                      Text(
                        '${(student.progressScore * 100).toInt()}%',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getProgressColor(colorScheme, student.progressScore),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: student.progressScore,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    color: _getProgressColor(colorScheme, student.progressScore),
                    minHeight: 8,
                    borderRadius: EduSupportTheme.radiusSm,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Actions
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 320) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      EduButton(
                        label: 'Message',
                        leading: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                        variant: EduButtonVariant.secondary,
                        onPressed: () => showNotImplementedSnackBar(context),
                      ),
                      const SizedBox(height: 12),
                      EduButton(
                        label: 'Schedule',
                        leading: const Icon(Icons.calendar_month_outlined, size: 16),
                        variant: EduButtonVariant.primary,
                        onPressed: () => showNotImplementedSnackBar(context),
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: EduButton(
                        label: 'Message',
                        leading: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                        variant: EduButtonVariant.secondary,
                        onPressed: () => showNotImplementedSnackBar(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: EduButton(
                        label: 'Schedule',
                        leading: const Icon(Icons.calendar_month_outlined, size: 16),
                        variant: EduButtonVariant.primary,
                        onPressed: () => showNotImplementedSnackBar(context),
                      ),
                    ),
                  ],
                );
              }
            ),
            const SizedBox(height: 32),
            
            // Notes Section
            EduSectionHeader(
              title: 'Tutor Notes',
              action: TextButton(
                onPressed: () {
                  if (_isEditingNotes) {
                    // Save
                    ref.read(tutorNotesProvider(student.id).notifier).state = _notesController.text;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notes saved successfully')),
                    );
                  } else {
                    if (_notesController.text.isEmpty && savedNotes.isNotEmpty) {
                      _notesController.text = savedNotes;
                    }
                  }
                  setState(() => _isEditingNotes = !_isEditingNotes);
                },
                child: Text(
                  _isEditingNotes ? 'Save' : 'Edit',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            EduCard(
              padding: const EdgeInsets.all(20),
              child: _isEditingNotes
                  ? TextField(
                      controller: _notesController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Enter your notes here...',
                        border: InputBorder.none,
                      ),
                    )
                  : Text(
                      savedNotes.isEmpty
                          ? 'Add private notes about ${student.name.split(' ').first}\'s learning style, goals, or areas needing improvement.'
                          : savedNotes,
                      style: textTheme.bodyMedium?.copyWith(
                        color: savedNotes.isEmpty ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
                        fontStyle: savedNotes.isEmpty ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Color _getProgressColor(ColorScheme colorScheme, double score) {
    if (score >= 0.8) return colorScheme.primary;
    if (score >= 0.6) return colorScheme.secondary; // Warning tone
    return colorScheme.error;
  }
}
