import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'student_mock_data.dart';

// ─── Result Type ──────────────────────────────────────────────────────────────

class SubmitTaskResult {
  const SubmitTaskResult.success(this.submission) : error = null;
  const SubmitTaskResult.failure(this.error) : submission = null;

  final TaskSubmission? submission;
  final String? error;

  bool get isSuccess => submission != null;
}

// ─── Repository Interface ─────────────────────────────────────────────────────
// UI talks to this. Swap MockTaskRepository for a real implementation later.

abstract class TaskRepository {
  Future<List<StudentTask>> getTasks();
  Future<StudentTask?> getTaskById(String id);
  Future<SubmitTaskResult> submitTask(
    String taskId, {
    String? textResponse,
    String? fileName,
    String? fileSize,
    String? fileType,
  });
}

// ─── Mock Implementation ──────────────────────────────────────────────────────

class MockTaskRepository implements TaskRepository {
  /// Mutable in-memory list so state updates persist within the session.
  final List<StudentTask> _tasks = mockStudentTasks.map((t) => t).toList();

  @override
  Future<List<StudentTask>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_tasks);
  }

  @override
  Future<StudentTask?> getTaskById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<SubmitTaskResult> submitTask(
    String taskId, {
    String? textResponse,
    String? fileName,
    String? fileSize,
    String? fileType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1400)); // simulate upload

    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx == -1) return const SubmitTaskResult.failure('Task not found.');

    final task = _tasks[idx];
    if (task.status == TaskStatus.submitted || task.status == TaskStatus.graded) {
      return const SubmitTaskResult.failure('This task has already been submitted.');
    }

    final submission = TaskSubmission(
      id: 'sub-${DateTime.now().millisecondsSinceEpoch}',
      taskId: taskId,
      textResponse: textResponse,
      fileName: fileName,
      fileSize: fileSize,
      fileType: fileType,
      submittedAt: DateTime.now().toIso8601String(),
    );

    // Replace the task with an updated submitted version
    _tasks[idx] = StudentTask(
      id: task.id,
      title: task.title,
      subject: task.subject,
      grade: task.grade,
      description: task.description,
      instructions: task.instructions,
      tutorName: task.tutorName,
      tutorInitials: task.tutorInitials,
      dueDate: task.dueDate,
      dueDateLabel: task.dueDateLabel,
      status: TaskStatus.submitted,
      submissionType: task.submissionType,
      submission: submission,
      gradeFeedback: task.gradeFeedback,
    );

    return SubmitTaskResult.success(submission);
  }
}

// ─── Riverpod Providers ───────────────────────────────────────────────────────

final taskRepositoryProvider = Provider<TaskRepository>((_) => MockTaskRepository());

final tasksProvider = FutureProvider<List<StudentTask>>((ref) {
  return ref.read(taskRepositoryProvider).getTasks();
});
