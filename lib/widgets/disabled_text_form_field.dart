import 'package:flutter/material.dart';

class DisabledTextFormField extends StatelessWidget {
  const DisabledTextFormField({
    super.key,
    required this.initialValue,
    this.maxLines = 1,
  });
  
  final int maxLines;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      enabled: false,
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFC5C6CC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
