import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_search_field.dart';
import '../../data/tutor_mock_data.dart';
import '../widgets/resource_row.dart';

class TutorResourcesScreen extends ConsumerStatefulWidget {
  const TutorResourcesScreen({super.key});

  @override
  ConsumerState<TutorResourcesScreen> createState() => _TutorResourcesScreenState();
}

class _TutorResourcesScreenState extends ConsumerState<TutorResourcesScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final _categories = ['All', 'Videos', 'Documents', 'PDFs'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final allResources = ref.watch(tutorResourcesProvider);
    
    final filteredResources = allResources.where((resource) {
      // Category filter
      if (_selectedCategory != 'All') {
        if (_selectedCategory == 'Videos' && resource.type != 'video') return false;
        if (_selectedCategory == 'PDFs' && resource.type != 'pdf') return false;
        if (_selectedCategory == 'Documents' && (resource.type == 'video' || resource.type == 'pdf')) return false;
      }
      // Search filter
      if (_searchQuery.isEmpty) return true;
      return resource.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: EduSearchField(
              hintText: 'Search teaching materials...',
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = category);
                    },
                    backgroundColor: colorScheme.surface,
                    selectedColor: colorScheme.primaryContainer,
                    checkmarkColor: colorScheme.onPrimaryContainer,
                    labelStyle: TextStyle(
                      color: isSelected 
                          ? colorScheme.onPrimaryContainer 
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: filteredResources.length,
              itemBuilder: (context, index) {
                return ResourceRow(resource: filteredResources[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
