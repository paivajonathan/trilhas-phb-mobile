import 'package:flutter/material.dart';

class DecoratedLabel extends StatelessWidget {
  const DecoratedLabel({
    super.key,
    required String content,
  }) :
    _content = content;

  final String _content;

  @override
  Widget build(BuildContext context) {
    return Text(
      _content,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
