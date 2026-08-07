import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/student/data/tutor_reviews_mock.dart';
import '../widgets/edu_button.dart';

/// Bottom sheet that allows a student to rate and review a tutor
/// after a completed session.
///
/// [tutorId] — the tutor being rated.
/// [tutorName] — displayed in the header.
/// [sessionSubject] — pre-fills the session subject context.
/// [studentName] / [studentInitials] — used to attribute the review.
class RateTutorSheet extends ConsumerStatefulWidget {
  const RateTutorSheet({
    super.key,
    required this.tutorId,
    required this.tutorName,
    required this.sessionSubject,
    required this.studentName,
    required this.studentInitials,
  });

  final String tutorId;
  final String tutorName;
  final String sessionSubject;
  final String studentName;
  final String studentInitials;

  @override
  ConsumerState<RateTutorSheet> createState() => _RateTutorSheetState();
}

class _RateTutorSheetState extends ConsumerState<RateTutorSheet> {
  double _rating = 0;
  final _reviewController = TextEditingController();
  bool _isSubmitting = false;
  bool _submitted = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a star rating.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      ref.read(tutorRatingControllerProvider.notifier).submitReview(
            tutorId: widget.tutorId,
            studentName: widget.studentName,
            studentInitials: widget.studentInitials,
            rating: _rating,
            reviewText: _reviewController.text.trim().isEmpty
                ? 'No written review provided.'
                : _reviewController.text.trim(),
            sessionSubject: widget.sessionSubject,
          );
      setState(() {
        _isSubmitting = false;
        _submitted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      snap: true,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: _submitted
                    ? _SuccessView(tutorName: widget.tutorName)
                    : _RatingForm(
                        scrollController: scrollController,
                        tutorName: widget.tutorName,
                        sessionSubject: widget.sessionSubject,
                        rating: _rating,
                        reviewController: _reviewController,
                        isSubmitting: _isSubmitting,
                        onRatingChanged: (r) => setState(() => _rating = r),
                        onSubmit: _submit,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Rating Form ──────────────────────────────────────────────────────────────

class _RatingForm extends StatelessWidget {
  const _RatingForm({
    required this.scrollController,
    required this.tutorName,
    required this.sessionSubject,
    required this.rating,
    required this.reviewController,
    required this.isSubmitting,
    required this.onRatingChanged,
    required this.onSubmit,
  });

  final ScrollController scrollController;
  final String tutorName;
  final String sessionSubject;
  final double rating;
  final TextEditingController reviewController;
  final bool isSubmitting;
  final ValueChanged<double> onRatingChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
      children: [
        // Header
        Text(
          'Rate your session',
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          '$tutorName · $sessionSubject',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 28),

        // Star rating
        Text(
          'How would you rate this session?',
          style: theme.textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final star = i + 1;
            return GestureDetector(
              onTap: () => onRatingChanged(star.toDouble()),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: AnimatedScale(
                  scale: rating >= star ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    rating >= star ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 44,
                    color: rating >= star
                        ? const Color(0xFFF59E0B)
                        : theme.colorScheme.outlineVariant,
                  ),
                ),
              ),
            );
          }),
        ),
        if (rating > 0) ...[
          const SizedBox(height: 8),
          Center(
            child: Text(
              _ratingLabel(rating),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),

        // Written review
        Text(
          'Written review (optional)',
          style: theme.textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: reviewController,
          maxLines: 4,
          maxLength: 400,
          decoration: InputDecoration(
            hintText:
                'Share your experience with future students…',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: theme.colorScheme.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: isSubmitting ? null : onSubmit,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Submit Review'),
          ),
        ),
      ],
    );
  }

  String _ratingLabel(double rating) {
    if (rating == 5) return 'Excellent!';
    if (rating == 4) return 'Very Good';
    if (rating == 3) return 'Good';
    if (rating == 2) return 'Fair';
    return 'Poor';
  }
}

// ─── Success View ─────────────────────────────────────────────────────────────

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.tutorName});
  final String tutorName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('⭐', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 20),
          Text(
            'Thank you!',
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Your review of $tutorName has been submitted. It helps other students make informed choices.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}
