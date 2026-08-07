// Mock tutor reviews — frontend only.
// Covers all 5 mock tutors (t1–t5) with realistic review content
// matching the Malawian academic context.

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

class TutorReview {
  TutorReview({
    required this.id,
    required this.tutorId,
    required this.studentName,
    required this.studentInitials,
    required this.rating,
    required this.reviewText,
    required this.dateLabel,
    this.sessionSubject,
    this.isPositive = true,
  });

  final String id;
  final String tutorId;
  final String studentName;
  final String studentInitials;
  final double rating; // 1.0 – 5.0
  final String reviewText;
  final String dateLabel;
  final String? sessionSubject;
  final bool isPositive;
}

// ─── Mock Data ────────────────────────────────────────────────────────────────

final _mockTutorReviews = <TutorReview>[
  // Tutor t1 — Dr. Amara Nkosi (Mathematics & Physics)
  TutorReview(
    id: 'rv1',
    tutorId: 't1',
    studentName: 'Grace Banda',
    studentInitials: 'GB',
    rating: 5.0,
    reviewText:
        'Dr. Nkosi is an exceptional tutor. He explains calculus with incredible clarity and patience. My exam results improved dramatically after just four sessions. I finally understand integration.',
    dateLabel: '2 weeks ago',
    sessionSubject: 'Mathematics',
  ),
  TutorReview(
    id: 'rv2',
    tutorId: 't1',
    studentName: 'Emmanuel Chirwa',
    studentInitials: 'EC',
    rating: 5.0,
    reviewText:
        'Outstanding teaching style. He adapts to how you learn and ensures you truly understand before moving on. Physics went from my weakest subject to my strongest.',
    dateLabel: '1 month ago',
    sessionSubject: 'Physics',
  ),
  TutorReview(
    id: 'rv3',
    tutorId: 't1',
    studentName: 'Lucia Tembo',
    studentInitials: 'LT',
    rating: 4.5,
    reviewText:
        'Very knowledgeable and professional. Sessions are always well-prepared. Sometimes goes a little fast, but always happy to slow down when asked.',
    dateLabel: '2 months ago',
    sessionSubject: 'Mathematics',
  ),
  // Tutor t2 — Chisomo Banda (Biology & Chemistry)
  TutorReview(
    id: 'rv4',
    tutorId: 't2',
    studentName: 'Peter Mhango',
    studentInitials: 'PM',
    rating: 5.0,
    reviewText:
        'Chisomo made Biology so much more interesting. Her approach to breaking down complex biological processes into simple steps is excellent. Highly recommended for MSCE prep.',
    dateLabel: '3 weeks ago',
    sessionSubject: 'Biology',
  ),
  TutorReview(
    id: 'rv5',
    tutorId: 't2',
    studentName: 'Faith Msowoya',
    studentInitials: 'FM',
    rating: 4.5,
    reviewText:
        'Best Biology tutor I have had. She is passionate about the subject and that energy is contagious. Chemistry sessions are equally good.',
    dateLabel: '1 month ago',
    sessionSubject: 'Chemistry',
  ),
  // Tutor t3 — Takondwa Phiri (English Literature)
  TutorReview(
    id: 'rv6',
    tutorId: 't3',
    studentName: 'Kondwani Phiri',
    studentInitials: 'KP',
    rating: 5.0,
    reviewText:
        'Takondwa completely transformed how I write essays. My critical analysis improved significantly and I finally understand what examiners are looking for in Literature responses.',
    dateLabel: '2 weeks ago',
    sessionSubject: 'English Literature',
  ),
  TutorReview(
    id: 'rv7',
    tutorId: 't3',
    studentName: 'Amelia Nyirenda',
    studentInitials: 'AN',
    rating: 4.5,
    reviewText:
        'Very engaging sessions. Takondwa uses real examples from texts to explain analytical writing techniques. My essay grades improved by two grades.',
    dateLabel: '6 weeks ago',
    sessionSubject: 'English Language',
  ),
  // Tutor t4 — Mercy Kayira (Geography & History)
  TutorReview(
    id: 'rv8',
    tutorId: 't4',
    studentName: 'Tiwonge Mvula',
    studentInitials: 'TM',
    rating: 4.5,
    reviewText:
        'Mercy has a wonderful way of making Geography come alive. Her use of real-world case studies makes the subject very engaging and easy to remember for exams.',
    dateLabel: '1 month ago',
    sessionSubject: 'Geography',
  ),
  // Tutor t5 — Jonathan Mwale (Commerce & Accounting)
  TutorReview(
    id: 'rv9',
    tutorId: 't5',
    studentName: 'Chimwemwe Kachingwe',
    studentInitials: 'CK',
    rating: 4.0,
    reviewText:
        'Jonathan has solid knowledge of Commerce and Accounting. Sessions are structured and practical. Would have appreciated more worked examples in some topics.',
    dateLabel: '3 weeks ago',
    sessionSubject: 'Accounting',
  ),
];

List<TutorReview> reviewsForTutor(String tutorId) =>
    _mockTutorReviews.where((r) => r.tutorId == tutorId).toList();

double averageRatingForTutor(String tutorId) {
  final reviews = reviewsForTutor(tutorId);
  if (reviews.isEmpty) return 0.0;
  return reviews.fold(0.0, (sum, r) => sum + r.rating) / reviews.length;
}

// ─── Rating Controller ────────────────────────────────────────────────────────
// Allows a student to submit a rating for a completed session.

class TutorRatingController extends StateNotifier<List<TutorReview>> {
  TutorRatingController() : super(List.from(_mockTutorReviews));

  void submitReview({
    required String tutorId,
    required String studentName,
    required String studentInitials,
    required double rating,
    required String reviewText,
    String? sessionSubject,
  }) {
    final newReview = TutorReview(
      id: 'rv_${DateTime.now().millisecondsSinceEpoch}',
      tutorId: tutorId,
      studentName: studentName,
      studentInitials: studentInitials,
      rating: rating,
      reviewText: reviewText,
      dateLabel: 'Just now',
      sessionSubject: sessionSubject,
    );
    state = [...state, newReview];
  }

  List<TutorReview> reviewsFor(String tutorId) =>
      state.where((r) => r.tutorId == tutorId).toList();
}

final tutorRatingControllerProvider =
    StateNotifierProvider<TutorRatingController, List<TutorReview>>(
  (ref) => TutorRatingController(),
);
