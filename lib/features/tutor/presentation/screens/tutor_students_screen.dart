import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_search_field.dart';
import '../../data/tutor_mock_data.dart';
import '../widgets/student_list_row.dart';
import 'tutor_student_detail_screen.dart';

class TutorStudentsScreen extends ConsumerStatefulWidget {
  const TutorStudentsScreen({super.key});

  @override
  ConsumerState<TutorStudentsScreen> createState() => _TutorStudentsScreenState();
}

class _TutorStudentsScreenState extends ConsumerState<TutorStudentsScreen> {
  String _searchQuery = '';
  bool _showNeedsAttentionOnly = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final allStudents = ref.watch(tutorStudentsProvider);
    
    final filteredStudents = allStudents.where((student) {
      if (_showNeedsAttentionOnly && !student.needsAttention) return false;
      if (_searchQuery.isEmpty) return true;
      return student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             student.subject.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: EduSearchField(
              hintText: 'Search students by name or subject...',
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All Students'),
                  selected: !_showNeedsAttentionOnly,
                  onSelected: (val) {
                    if (val) setState(() => _showNeedsAttentionOnly = false);
                  },
                  backgroundColor: colorScheme.surface,
                  selectedColor: colorScheme.primaryContainer,
                  checkmarkColor: colorScheme.onPrimaryContainer,
                  labelStyle: TextStyle(
                    color: !_showNeedsAttentionOnly 
                        ? colorScheme.onPrimaryContainer 
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Needs Attention'),
                  selected: _showNeedsAttentionOnly,
                  onSelected: (val) {
                    if (val) setState(() => _showNeedsAttentionOnly = true);
                  },
                  backgroundColor: colorScheme.surface,
                  selectedColor: colorScheme.errorContainer,
                  checkmarkColor: colorScheme.onErrorContainer,
                  labelStyle: TextStyle(
                    color: _showNeedsAttentionOnly 
                        ? colorScheme.onErrorContainer 
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
                return StudentListRow(
                  student: student,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => TutorStudentDetailScreen(student: student),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
