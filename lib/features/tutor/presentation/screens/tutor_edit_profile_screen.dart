import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_button.dart';
import '../../../../theme/app_theme.dart';
import '../../application/tutor_profile_controller.dart';

class TutorEditProfileScreen extends ConsumerStatefulWidget {
  const TutorEditProfileScreen({super.key});

  @override
  ConsumerState<TutorEditProfileScreen> createState() =>
      _TutorEditProfileScreenState();
}

class _TutorEditProfileScreenState
    extends ConsumerState<TutorEditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late TextEditingController _teachingStyleController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(tutorProfileProvider);
    _nameController = TextEditingController(text: profile.name);
    _phoneController = TextEditingController(text: profile.phone);
    _bioController = TextEditingController(text: profile.bio);
    _locationController = TextEditingController(text: profile.location);
    _teachingStyleController =
        TextEditingController(text: profile.teachingStyle);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _teachingStyleController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    // Simulate network save
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      final current = ref.read(tutorProfileProvider);
      ref.read(tutorProfileProvider.notifier).updateProfile(
            current.copyWith(
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              bio: _bioController.text.trim(),
              location: _locationController.text.trim(),
              teachingStyle: _teachingStyleController.text.trim(),
            ),
          );

      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Edit Professional Profile'),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: Text(
                'Save',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(title: 'Personal Information'),
              const SizedBox(height: 16),
              _TextField(
                label: 'Full Name',
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              _TextField(
                label: 'Phone Number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _TextField(
                label: 'Location',
                controller: _locationController,
              ),

              const SizedBox(height: 32),
              _SectionTitle(title: 'Professional Bio'),
              const SizedBox(height: 16),
              _TextField(
                label: 'About Me',
                controller: _bioController,
                maxLines: 5,
                hintText: 'Introduce yourself to potential students...',
              ),

              const SizedBox(height: 32),
              _SectionTitle(title: 'Teaching Approach'),
              const SizedBox(height: 16),
              _TextField(
                label: 'Teaching Style',
                controller: _teachingStyleController,
                maxLines: 4,
                hintText: 'Describe how you conduct your sessions...',
              ),

              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: EduButton(
                  label: _isSaving ? 'Saving…' : 'Save Changes',
                  onPressed: _isSaving ? null : _saveProfile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.hintText,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
