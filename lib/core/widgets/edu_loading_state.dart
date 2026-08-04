import 'package:flutter/material.dart';

class EduLoadingState extends StatelessWidget {
  const EduLoadingState({super.key, this.message = 'Loading EduSupport…'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
