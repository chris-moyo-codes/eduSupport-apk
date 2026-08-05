import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_text_field.dart';
import '../../../../theme/app_theme.dart';
import '../../../student/data/student_mock_data.dart';
import '../../../student/data/task_repository.dart';

enum _SaveState { idle, saving, success, error }

class TutorTaskReviewScreen extends ConsumerStatefulWidget {
  const TutorTaskReviewScreen({super.key, required this.taskId});

  final String taskId;

  @override
  ConsumerState<TutorTaskReviewScreen> createState() => _TutorTaskReviewScreenState();
}

class _TutorTaskReviewScreenState extends ConsumerState<TutorTaskReviewScreen> {
  StudentTask? _task;
  bool _loading = true;

  final _gradeController = TextEditingController();
  final _feedbackController = TextEditingController();

  _SaveState _saveState = _SaveState.idle;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  @override
  void dispose() {
    _gradeController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _loadTask() async {
    final repo = ref.read(taskRepositoryProvider);
    final task = await repo.getTaskById(widget.taskId);
    if (mounted) {
      setState(() {
        _task = task;
        _loading = false;
      });
    }
  }

  Future<void> _saveReview() async {
    final grade = _gradeController.text.trim();
    final feedback = _feedbackController.text.trim();

    if (grade.isEmpty || feedback.isEmpty) {
      setState(() {
        _saveState = _SaveState.error;
        _errorMsg = 'Please provide both a grade and feedback.';
      });
      return;
    }

    setState(() {
      _saveState = _SaveState.saving;
      _errorMsg = null;
    });

    final repo = ref.read(taskRepositoryProvider);
    final error = await repo.gradeSubmission(widget.taskId, grade, feedback);

    if (mounted) {
      if (error == null) {
        setState(() {
          _saveState = _SaveState.success;
          _task = _task == null
              ? null
              : StudentTask(
                  id: _task!.id,
                  title: _task!.title,
                  subject: _task!.subject,
                  grade: _task!.grade,
                  description: _task!.description,
                  instructions: _task!.instructions,
                  tutorName: _task!.tutorName,
                  tutorInitials: _task!.tutorInitials,
                  dueDate: _task!.dueDate,
                  dueDateLabel: _task!.dueDateLabel,
                  status: TaskStatus.graded,
                  submissionType: _task!.submissionType,
                  submission: _task!.submission,
                  awardedGrade: grade,
                  gradeFeedback: feedback,
                );
        });
        ref.invalidate(tasksProvider); // refresh list
      } else {
        setState(() {
          _saveState = _SaveState.error;
          _errorMsg = error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review Submission'), elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review Submission'), elevation: 0),
        body: const Center(child: Text('Submission not found.')),
      );
    }

    final task = _task!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Review Submission',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Context Header ───────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: EduSupportTheme.radiusXl,
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'S', // Mock student initial
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Student Submission',
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            if (task.submission?.submittedAt != null)
                              Text(
                                'Submitted: ${task.submission!.submittedAt.split('T').first}',
                                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1),
                  ),
                  Text(
                    task.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.instructions,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Student's Work ───────────────────────────────────────────
            Text(
              'STUDENT\'S WORK',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            if (task.submission?.textResponse != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: EduSupportTheme.radiusLg,
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Text(
                  task.submission!.textResponse!,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
              ),

            if (task.submission?.fileName != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: EduSupportTheme.radiusMd,
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: EduSupportTheme.radiusSm,
                      ),
                      child: Icon(Icons.description_outlined, color: Colors.blue.shade700),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.submission!.fileName!,
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${task.submission!.fileType} · ${task.submission!.fileSize}',
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.open_in_new_rounded, size: 20, color: theme.colorScheme.primary),
                  ],
                ),
              ),

            const SizedBox(height: 32),

            // ── Evaluation ───────────────────────────────────────────────
            Row(
              children: [
                Icon(Icons.star_rounded, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'EVALUATION',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (task.status == TaskStatus.graded) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: EduSupportTheme.radiusLg,
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle_outline_rounded, size: 18, color: Colors.green.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'Reviewed',
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green.shade800),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.green.shade300),
                          ),
                          child: Text(
                            'Grade: ${task.awardedGrade}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.green.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      task.gradeFeedback ?? '',
                      style: TextStyle(color: Colors.green.shade900, height: 1.5),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: EduSupportTheme.radiusLg,
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EduTextField(
                      label: 'Grade',
                      hintText: 'e.g. 8/10, A, Pass',
                      controller: _gradeController,
                      enabled: _saveState != _SaveState.saving,
                    ),
                    const SizedBox(height: 16),
                    EduTextField(
                      label: 'Feedback',
                      hintText: 'Provide constructive feedback for the student...',
                      controller: _feedbackController,
                      maxLines: 5,
                      enabled: _saveState != _SaveState.saving,
                    ),
                    if (_saveState == _SaveState.error && _errorMsg != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withValues(alpha: 0.1),
                          borderRadius: EduSupportTheme.radiusSm,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline_rounded, size: 16, color: theme.colorScheme.error),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMsg!,
                                style: TextStyle(color: theme.colorScheme.error, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    EduButton(
                      label: _saveState == _SaveState.saving
                          ? 'Saving...'
                          : _saveState == _SaveState.success
                              ? 'Saved'
                              : 'Save Review',
                      fullWidth: true,
                      onPressed: _saveReview,
                      loading: _saveState == _SaveState.saving,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
