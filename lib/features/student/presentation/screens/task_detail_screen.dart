import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_text_field.dart';
import '../../../../theme/app_theme.dart';
import '../../data/student_mock_data.dart';
import '../../data/task_repository.dart';
import 'tasks_screen.dart' show taskStatusBadge;

enum _SubmitState { idle, submitting, success, error }

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  StudentTask? _task;
  bool _loading = true;

  _SubmitState _submitState = _SubmitState.idle;
  final _textController = TextEditingController();
  _MockFile? _mockFile;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    final repo = ref.read(taskRepositoryProvider);
    final task = await repo.getTaskById(widget.taskId);
    if (mounted) {
      setState(() {
        _task = task;
        _loading = false;
        if (task != null) {
          _textController.text = task.submission?.textResponse ?? '';
          if (task.submission?.fileName != null) {
            _mockFile = _MockFile(
              name: task.submission!.fileName!,
              size: task.submission!.fileSize ?? '',
              type: task.submission!.fileType ?? '',
            );
          }
          if (task.status == TaskStatus.submitted || task.status == TaskStatus.graded) {
            _submitState = _SubmitState.success;
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _pickMockFile() {
    final files = [
      _MockFile(name: '${_task!.subject.toLowerCase()}_work_jonathan.pdf', size: '1.4 MB', type: 'PDF'),
      _MockFile(name: 'task_scan.jpg', size: '2.8 MB', type: 'Image'),
      _MockFile(name: '${_task!.subject.toLowerCase()}_assignment.docx', size: '0.8 MB', type: 'Word'),
    ];
    setState(() {
      _mockFile = files[DateTime.now().millisecond % files.length];
    });
  }

  String? _validate() {
    if (_task == null) return null;
    final text = _textController.text.trim();
    if (_task!.submissionType == SubmissionType.text && text.isEmpty) {
      return 'Please write your response before submitting.';
    }
    if (_task!.submissionType == SubmissionType.file && _mockFile == null) {
      return 'Please attach a file before submitting.';
    }
    if (_task!.submissionType == SubmissionType.both && text.isEmpty && _mockFile == null) {
      return 'Please write a response or attach a file (or both).';
    }
    return null;
  }

  Future<void> _submit() async {
    final validationError = _validate();
    if (validationError != null) {
      setState(() {
        _errorMsg = validationError;
        _submitState = _SubmitState.error;
      });
      return;
    }

    setState(() {
      _submitState = _SubmitState.submitting;
      _errorMsg = null;
    });

    final repo = ref.read(taskRepositoryProvider);
    final result = await repo.submitTask(
      widget.taskId,
      textResponse: _textController.text.trim().isEmpty ? null : _textController.text.trim(),
      fileName: _mockFile?.name,
      fileSize: _mockFile?.size,
      fileType: _mockFile?.type,
    );

    if (mounted) {
      if (result.isSuccess) {
        setState(() {
          _submitState = _SubmitState.success;
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
                  status: TaskStatus.submitted,
                  submissionType: _task!.submissionType,
                  submission: result.submission,
                );
        });
        // Invalidate the tasks list provider so the list reflects the new status
        ref.invalidate(tasksProvider);
      } else {
        setState(() {
          _submitState = _SubmitState.error;
          _errorMsg = result.error ?? 'Submission failed. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task'), elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task'), elevation: 0),
        body: const Center(child: Text('Task not found.')),
      );
    }

    final task = _task!;
    final badge = taskStatusBadge(task.status);
    final isAlreadySubmitted = task.status == TaskStatus.submitted || task.status == TaskStatus.graded;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          task.subject,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Task Header ──────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: EduSupportTheme.radiusXl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      EduBadge(label: badge.label, tone: badge.tone),
                      const Spacer(),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          task.tutorInitials,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    task.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${task.subject} · ${task.grade}',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: 16, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(
                        'Due ${task.dueDateLabel}',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.person_outline_rounded, size: 16, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          task.tutorName,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Description ──────────────────────────────────────────────
            _SectionCard(
              label: 'Overview',
              child: Text(task.description, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
            ),

            const SizedBox(height: 12),

            // ── Instructions ─────────────────────────────────────────────
            _SectionCard(
              label: 'Instructions',
              child: Text(task.instructions, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
            ),

            // ── Graded Feedback ──────────────────────────────────────────
            if (task.status == TaskStatus.graded && task.gradeFeedback != null) ...[
              const SizedBox(height: 12),
              _SectionCard(
                label: 'Tutor Feedback',
                labelColor: Colors.green.shade700,
                backgroundColor: Colors.green.shade50,
                child: Text(
                  task.gradeFeedback!,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.6, color: Colors.green.shade900),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // ── Submission Area ──────────────────────────────────────────
            if (!isAlreadySubmitted) ...[
              Text(
                'Your Submission',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),

              // Text response
              if (task.submissionType == SubmissionType.text || task.submissionType == SubmissionType.both) ...[
                EduTextField(
                  label: 'Written Response',
                  hintText: 'Write your response here...',
                  controller: _textController,
                  enabled: _submitState != _SubmitState.submitting,
                  maxLines: 7,
                ),
                const SizedBox(height: 16),
              ],

              // File attachment
              if (task.submissionType == SubmissionType.file || task.submissionType == SubmissionType.both) ...[
                if (_mockFile != null)
                  _AttachedFileTile(
                    file: _mockFile!,
                    onRemove: _submitState == _SubmitState.submitting ? null : () => setState(() => _mockFile = null),
                  )
                else
                  _FilePickerButton(onTap: _submitState == _SubmitState.submitting ? null : _pickMockFile),
                const SizedBox(height: 16),
              ],

              // Validation error
              if (_submitState == _SubmitState.error && _errorMsg != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withValues(alpha: 0.08),
                    borderRadius: EduSupportTheme.radiusMd,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.error_outline_rounded, size: 18, color: theme.colorScheme.error),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(_errorMsg!, style: TextStyle(color: theme.colorScheme.error, fontSize: 14, height: 1.4)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Submit button
              EduButton(
                label: _submitState == _SubmitState.submitting
                    ? 'Submitting...'
                    : _submitState == _SubmitState.error
                        ? 'Try Again'
                        : 'Submit Work',
                fullWidth: true,
                size: EduButtonSize.large,
                loading: _submitState == _SubmitState.submitting,
                onPressed: _submit,
              ),
            ] else ...[
              // ── Submitted / Graded View ──────────────────────────────
              _SubmittedView(task: task),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Supporting Widgets ───────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.label,
    required this.child,
    this.labelColor,
    this.backgroundColor,
  });

  final String label;
  final Widget child;
  final Color? labelColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: EduSupportTheme.radiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: labelColor ?? theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _MockFile {
  const _MockFile({required this.name, required this.size, required this.type});
  final String name;
  final String size;
  final String type;
}

class _AttachedFileTile extends StatelessWidget {
  const _AttachedFileTile({required this.file, this.onRemove});

  final _MockFile file;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: EduSupportTheme.radiusMd,
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: EduSupportTheme.radiusSm,
            ),
            child: Icon(Icons.insert_drive_file_rounded, color: theme.colorScheme.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('${file.type} · ${file.size}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          if (onRemove != null)
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.close_rounded, size: 18),
              color: theme.colorScheme.onSurfaceVariant,
              tooltip: 'Remove file',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
        ],
      ),
    );
  }
}

class _FilePickerButton extends StatelessWidget {
  const _FilePickerButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: EduSupportTheme.radiusMd,
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.5), style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Icon(Icons.attach_file_rounded, size: 28, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 8),
            Text('Tap to attach a file', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text('PDF, Word, or Image', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _SubmittedView extends StatelessWidget {
  const _SubmittedView({required this.task});

  final StudentTask task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGraded = task.status == TaskStatus.graded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isGraded ? Colors.green.shade50 : Colors.blue.shade50,
        borderRadius: EduSupportTheme.radiusXl,
        border: Border.all(color: isGraded ? Colors.green.shade200 : Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_rounded, color: isGraded ? Colors.green.shade600 : Colors.blue.shade600, size: 22),
              const SizedBox(width: 8),
              Text(
                isGraded ? 'Work received and graded' : 'Work submitted · Awaiting review',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isGraded ? Colors.green.shade800 : Colors.blue.shade800),
              ),
            ],
          ),
          if (task.submission?.submittedAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Submitted on ${_formatDate(task.submission!.submittedAt)}',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
          if (task.submission?.textResponse != null) ...[
            const SizedBox(height: 16),
            Text('Written Response', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, letterSpacing: 0.5)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: EduSupportTheme.radiusMd,
              ),
              child: Text(task.submission!.textResponse!, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
            ),
          ],
          if (task.submission?.fileName != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.insert_drive_file_rounded, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.submission!.fileName!, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                      Text('${task.submission!.fileType} · ${task.submission!.fileSize}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          ],
          if (!isGraded) ...[
            const SizedBox(height: 12),
            Text(
              'Your tutor will review this and provide feedback soon.',
              style: TextStyle(fontSize: 12, color: Colors.blue.shade600, fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final d = DateTime.parse(iso).toLocal();
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${d.day} ${months[d.month - 1]} ${d.year}';
    } catch (_) {
      return iso;
    }
  }
}
