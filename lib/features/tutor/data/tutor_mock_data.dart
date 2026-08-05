// DEMO-ONLY TUTOR MOCK DATA
// ──────────────────────────
// This module provides frontend-only data simulating a backend for the Tutor experience.

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

enum SessionStatus { scheduled, completed, cancelled, inProgress }

class TutorStudent {
  const TutorStudent({
    required this.id,
    required this.name,
    required this.initials,
    required this.grade,
    required this.subject,
    required this.progressScore,
    required this.lastActive,
    required this.needsAttention,
  });

  final String id;
  final String name;
  final String initials;
  final String grade;
  final String subject;
  final double progressScore; // 0.0 to 1.0
  final DateTime lastActive;
  final bool needsAttention;
}

class TutorSession {
  const TutorSession({
    required this.id,
    required this.studentId,
    required this.subject,
    required this.startTime,
    required this.durationMinutes,
    required this.status,
    this.notes,
  });

  final String id;
  final String studentId;
  final String subject;
  final DateTime startTime;
  final int durationMinutes;
  final SessionStatus status;
  final String? notes;
}

class TutorResource {
  const TutorResource({
    required this.id,
    required this.title,
    required this.type,
    required this.sizeMb,
    required this.uploadDate,
    required this.downloadCount,
  });

  final String id;
  final String title;
  final String type; // e.g., 'pdf', 'video', 'doc'
  final double sizeMb;
  final DateTime uploadDate;
  final int downloadCount;
}

class TutorMetrics {
  const TutorMetrics({
    required this.activeStudents,
    required this.hoursTaught,
    required this.upcomingSessions,
    required this.averageRating,
  });

  final int activeStudents;
  final int hoursTaught;
  final int upcomingSessions;
  final double averageRating;
}

// ─── Mock Data ────────────────────────────────────────────────────────────────

final _now = DateTime.now();

final mockTutorStudents = [
  TutorStudent(
    id: 's_1',
    name: 'Maya Patel',
    initials: 'MP',
    grade: '10th Grade',
    subject: 'AP Physics',
    progressScore: 0.85,
    lastActive: _now.subtract(const Duration(hours: 2)),
    needsAttention: false,
  ),
  TutorStudent(
    id: 's_2',
    name: 'Leo Smith',
    initials: 'LS',
    grade: '9th Grade',
    subject: 'Algebra I',
    progressScore: 0.45,
    lastActive: _now.subtract(const Duration(days: 3)),
    needsAttention: true,
  ),
  TutorStudent(
    id: 's_3',
    name: 'Sarah Jenkins',
    initials: 'SJ',
    grade: '11th Grade',
    subject: 'Biology',
    progressScore: 0.92,
    lastActive: _now.subtract(const Duration(minutes: 45)),
    needsAttention: false,
  ),
  TutorStudent(
    id: 's_4',
    name: 'David Chen',
    initials: 'DC',
    grade: '12th Grade',
    subject: 'AP Calculus BC',
    progressScore: 0.78,
    lastActive: _now.subtract(const Duration(days: 1)),
    needsAttention: false,
  ),
  TutorStudent(
    id: 's_5',
    name: 'Emma Wilson',
    initials: 'EW',
    grade: '8th Grade',
    subject: 'Pre-Algebra',
    progressScore: 0.55,
    lastActive: _now.subtract(const Duration(days: 2)),
    needsAttention: true,
  ),
];

final mockTutorSessions = [
  // Past completed
  TutorSession(
    id: 'ses_1',
    studentId: 's_1',
    subject: 'AP Physics - Kinematics',
    startTime: _now.subtract(const Duration(days: 2, hours: 3)),
    durationMinutes: 60,
    status: SessionStatus.completed,
    notes: 'Maya is grasping kinematics well but struggled slightly with projectile motion formulas. Assigned extra practice questions.',
  ),
  TutorSession(
    id: 'ses_2',
    studentId: 's_2',
    subject: 'Algebra I - Linear Equations',
    startTime: _now.subtract(const Duration(days: 1, hours: 5)),
    durationMinutes: 45,
    status: SessionStatus.completed,
    notes: 'Leo is still confused about isolating variables. We need to step back and review the basics next time.',
  ),
  // Upcoming
  TutorSession(
    id: 'ses_3',
    studentId: 's_3',
    subject: 'Biology - Cell Organelles',
    startTime: _now.add(const Duration(hours: 2)),
    durationMinutes: 60,
    status: SessionStatus.scheduled,
  ),
  TutorSession(
    id: 'ses_4',
    studentId: 's_1',
    subject: 'AP Physics - Dynamics',
    startTime: _now.add(const Duration(days: 1, hours: 2)),
    durationMinutes: 60,
    status: SessionStatus.scheduled,
  ),
  TutorSession(
    id: 'ses_5',
    studentId: 's_4',
    subject: 'AP Calculus BC - Integrals',
    startTime: _now.add(const Duration(days: 2, hours: 4)),
    durationMinutes: 90,
    status: SessionStatus.scheduled,
  ),
];

final mockTutorResources = [
  TutorResource(
    id: 'r_1',
    title: 'Kinematics Formula Sheet',
    type: 'pdf',
    sizeMb: 1.2,
    uploadDate: _now.subtract(const Duration(days: 14)),
    downloadCount: 45,
  ),
  TutorResource(
    id: 'r_2',
    title: 'Introduction to Derivatives',
    type: 'video',
    sizeMb: 124.5,
    uploadDate: _now.subtract(const Duration(days: 30)),
    downloadCount: 112,
  ),
  TutorResource(
    id: 'r_3',
    title: 'Cell Biology Review Packet',
    type: 'doc',
    sizeMb: 3.4,
    uploadDate: _now.subtract(const Duration(days: 5)),
    downloadCount: 18,
  ),
  TutorResource(
    id: 'r_4',
    title: 'Algebra Practice Set: Variables',
    type: 'pdf',
    sizeMb: 0.8,
    uploadDate: _now.subtract(const Duration(days: 2)),
    downloadCount: 8,
  ),
];

const mockTutorMetrics = TutorMetrics(
  activeStudents: 12,
  hoursTaught: 142,
  upcomingSessions: 8,
  averageRating: 4.9,
);

// ─── Providers ────────────────────────────────────────────────────────────────

final tutorStudentsProvider = Provider<List<TutorStudent>>((ref) => mockTutorStudents);

final tutorSessionsProvider = Provider<List<TutorSession>>((ref) {
  final sessions = List<TutorSession>.from(mockTutorSessions);
  sessions.sort((a, b) => a.startTime.compareTo(b.startTime));
  return sessions;
});

final tutorResourcesProvider = Provider<List<TutorResource>>((ref) => mockTutorResources);

final tutorMetricsProvider = Provider<TutorMetrics>((ref) => mockTutorMetrics);
