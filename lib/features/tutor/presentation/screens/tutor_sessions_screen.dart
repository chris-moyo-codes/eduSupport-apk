import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/tutor_mock_data.dart';
import '../widgets/tutor_session_tile.dart';
import 'tutor_session_detail_screen.dart';

class TutorSessionsScreen extends ConsumerStatefulWidget {
  const TutorSessionsScreen({super.key, this.isStandalone = false});

  final bool isStandalone;

  @override
  ConsumerState<TutorSessionsScreen> createState() => _TutorSessionsScreenState();
}

class _TutorSessionsScreenState extends ConsumerState<TutorSessionsScreen> {
  bool _showUpcoming = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final allSessions = ref.watch(tutorSessionsProvider);
    final students = ref.watch(tutorStudentsProvider);
    
    final filteredSessions = allSessions.where((s) {
      if (_showUpcoming) {
        return s.status == SessionStatus.scheduled || s.status == SessionStatus.inProgress;
      } else {
        return s.status == SessionStatus.completed || s.status == SessionStatus.cancelled;
      }
    }).toList();

    // Sort appropriately
    if (_showUpcoming) {
      filteredSessions.sort((a, b) => a.startTime.compareTo(b.startTime));
    } else {
      filteredSessions.sort((a, b) => b.startTime.compareTo(a.startTime)); // Newest past first
    }

    Widget content = Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: true,
                label: Text('Upcoming'),
                icon: Icon(Icons.calendar_today_rounded),
              ),
              ButtonSegment(
                value: false,
                label: Text('Completed'),
                icon: Icon(Icons.history_rounded),
              ),
            ],
            selected: {_showUpcoming},
            onSelectionChanged: (set) {
              setState(() => _showUpcoming = set.first);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return colorScheme.primaryContainer;
                }
                return colorScheme.surface;
              }),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(16, 8, 16, widget.isStandalone ? 24 : 100),
            itemCount: filteredSessions.length,
            itemBuilder: (context, index) {
              final session = filteredSessions[index];
              final student = students.firstWhere(
                (s) => s.id == session.studentId,
                orElse: () => students.first, // fallback just in case
              );
              
              return TutorSessionTile(
                session: session,
                studentName: student.name,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => TutorSessionDetailScreen(session: session),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );

    if (widget.isStandalone) {
      return Scaffold(
        backgroundColor: colorScheme.surfaceContainerLowest,
        appBar: AppBar(
          title: const Text('Sessions'),
          backgroundColor: colorScheme.surface,
        ),
        body: content,
      );
    }

    return SafeArea(child: content);
  }
}
