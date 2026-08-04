import 'package:flutter/material.dart';

class EduSearchField extends StatelessWidget {
  const EduSearchField({
    super.key,
    this.controller,
    this.hintText = 'Search resources',
  });

  final TextEditingController? controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded),
      ),
    );
  }
}
