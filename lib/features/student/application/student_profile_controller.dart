// Student extended profile state.
// Kept separate from the auth layer (EduUser) which tracks only:
//   id, name, email, initials, role.
//
// StudentProfile tracks the full editable profile that would live in a
// "user_profiles" table in production. Editing here does NOT affect auth state.

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

class StudentProfile {
  const StudentProfile({
    required this.name,
    required this.email,
    this.phone = '',
    this.school = '',
    this.grade = '',
    this.subjects = const [],
    this.learningGoals = '',
    this.preferredLearningAreas = const [],
  });

  final String name;
  final String email;
  final String phone;
  final String school;
  final String grade;
  final List<String> subjects;
  final String learningGoals;
  final List<String> preferredLearningAreas;

  StudentProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? school,
    String? grade,
    List<String>? subjects,
    String? learningGoals,
    List<String>? preferredLearningAreas,
  }) {
    return StudentProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      school: school ?? this.school,
      grade: grade ?? this.grade,
      subjects: subjects ?? this.subjects,
      learningGoals: learningGoals ?? this.learningGoals,
      preferredLearningAreas:
          preferredLearningAreas ?? this.preferredLearningAreas,
    );
  }
}

// ─── Controller ───────────────────────────────────────────────────────────────

class StudentProfileController extends StateNotifier<StudentProfile> {
  StudentProfileController(StudentProfile initial) : super(initial);

  void updateProfile(StudentProfile updated) {
    state = updated;
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final studentProfileProvider =
    StateNotifierProvider<StudentProfileController, StudentProfile>((ref) {
  return StudentProfileController(
    const StudentProfile(
      name: 'Jonathan Doe',
      email: 'student@edusupport.demo',
      phone: '+265 991 234 567',
      school: 'Kamuzu Academy',
      grade: 'Grade 12',
      subjects: ['Mathematics', 'Physics', 'Biology', 'Chemistry'],
      learningGoals:
          'Pass MSCE with distinction and prepare for university entrance.',
      preferredLearningAreas: [
        'Exam preparation',
        'Concept review',
        'Problem solving',
      ],
    ),
  );
});
