import 'package:flutter/material.dart';

import '../../data/student_mock_data.dart';

/// Interactive flashcard viewer with card flip animation.
/// Matches the web /study/flashcards/:id experience.
class FlashcardViewerScreen extends StatefulWidget {
  const FlashcardViewerScreen({super.key, required this.deck});

  final StudentFlashcardDeck deck;

  @override
  State<FlashcardViewerScreen> createState() => _FlashcardViewerScreenState();
}

class _FlashcardViewerScreenState extends State<FlashcardViewerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _frontRotation;
  late final Animation<double> _backRotation;

  int _currentIndex = 0;
  bool _showingFront = true;
  final Map<String, String> _cardStatuses = {};

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _frontRotation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0, end: -0.5), weight: 50),
      TweenSequenceItem(
          tween: ConstantTween(-0.5), weight: 50),
    ]).animate(_flipController);
    _backRotation = TweenSequence<double>([
      TweenSequenceItem(
          tween: ConstantTween(0.5), weight: 50),
      TweenSequenceItem(
          tween: Tween(begin: 0.5, end: 0), weight: 50),
    ]).animate(_flipController);

    for (final card in widget.deck.cards) {
      _cardStatuses[card.id] = 'unseen';
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  StudentFlashcard get _currentCard => widget.deck.cards[_currentIndex];
  bool get _isDone => _currentIndex >= widget.deck.cards.length;

  void _flip() {
    if (_flipController.isAnimating) return;
    if (_showingFront) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    setState(() => _showingFront = !_showingFront);
  }

  void _markCard(String status) {
    setState(() {
      _cardStatuses[_currentCard.id] = status;
      _showingFront = true;
    });
    _flipController.reset();

    if (_currentIndex < widget.deck.cards.length - 1) {
      setState(() => _currentIndex++);
    } else {
      setState(() => _currentIndex = widget.deck.cards.length); // triggers done state
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = widget.deck.cards.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.deck.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A202C),
          ),
        ),
        leading: const BackButton(color: Color(0xFF1A202C)),
      ),
      body: _isDone ? _buildDoneState(context, total) : _buildCardView(context, total, theme),
    );
  }

  Widget _buildCardView(BuildContext context, int total, ThemeData theme) {
    final progress = _currentIndex / total;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress bar
            Row(
              children: [
                Text(
                  '${_currentIndex + 1} of $total',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  widget.deck.subject,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: const Color(0xFFE4E2DC),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF212B36)),
              ),
            ),
            const SizedBox(height: 28),

            // Flip card
            Expanded(
              child: GestureDetector(
                onTap: _flip,
                child: Stack(
                  children: [
                    // Front
                    AnimatedBuilder(
                      animation: _frontRotation,
                      builder: (_, child) {
                        final angle = _frontRotation.value * 3.14159;
                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angle),
                          alignment: Alignment.center,
                          child: child,
                        );
                      },
                      child: _CardFace(
                        content: _currentCard.front,
                        label: 'QUESTION',
                        isVisible: _showingFront,
                        backgroundColor: const Color(0xFFFFFFFF),
                        labelColor: const Color(0xFF718096),
                        hint: 'Tap to reveal answer',
                      ),
                    ),
                    // Back
                    AnimatedBuilder(
                      animation: _backRotation,
                      builder: (_, child) {
                        final angle = _backRotation.value * 3.14159;
                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angle),
                          alignment: Alignment.center,
                          child: child,
                        );
                      },
                      child: _CardFace(
                        content: _currentCard.back,
                        label: 'ANSWER',
                        isVisible: !_showingFront,
                        backgroundColor: const Color(0xFF212B36),
                        labelColor: const Color(0x70FFFFFF),
                        textColor: Colors.white,
                        hint: null,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            if (!_showingFront) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _markCard('review'),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Review Again'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFC05621),
                        side: const BorderSide(color: Color(0xFFC05621)),
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _markCard('known'),
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Got it!'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF38A169),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _flip,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    side: const BorderSide(color: Color(0xFFE4E2DC)),
                  ),
                  child: const Text('Reveal Answer'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDoneState(BuildContext context, int total) {
    final known = _cardStatuses.values.where((s) => s == 'known').length;
    final review = _cardStatuses.values.where((s) => s == 'review').length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration_rounded,
                size: 64, color: Color(0xFFC05621)),
            const SizedBox(height: 24),
            const Text(
              'Deck Complete!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A202C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You reviewed all $total cards in ${widget.deck.title}.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Color(0xFF718096)),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ResultPill(count: known, label: 'Known', color: const Color(0xFF38A169)),
                const SizedBox(width: 24),
                _ResultPill(count: review, label: 'Review', color: const Color(0xFFC05621)),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF212B36),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Back to Study'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  const _CardFace({
    required this.content,
    required this.label,
    required this.isVisible,
    required this.backgroundColor,
    required this.labelColor,
    this.textColor,
    this.hint,
  });

  final String content;
  final String label;
  final bool isVisible;
  final Color backgroundColor;
  final Color labelColor;
  final Color? textColor;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    // Hide the back of the card when not visible to avoid double-painting
    if (!isVisible) return const SizedBox.expand();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: labelColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.5,
                color: textColor ?? const Color(0xFF1A202C),
              ),
            ),
            if (hint != null) ...[
              const SizedBox(height: 24),
              Text(
                hint!,
                style: TextStyle(
                  fontSize: 12,
                  color: labelColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultPill extends StatelessWidget {
  const _ResultPill({
    required this.count,
    required this.label,
    required this.color,
  });

  final int count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF718096),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
