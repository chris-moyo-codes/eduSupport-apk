import 'package:flutter/material.dart';

/// Shows a standardized snackbar for interactions that require backend integration.
/// This prevents empty taps during physical device validation.
void showNotImplementedSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('This feature will be available after backend integration.'),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

Future<bool?> showLogoutConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Sign out?'),
      content: const Text('Are you sure you want to sign out of your EduSupport account?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Sign Out'),
        ),
      ],
    ),
  );
}
