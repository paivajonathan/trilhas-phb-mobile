import 'dart:ui';
import 'package:flutter/material.dart';

class BlurryDialogWidget extends StatelessWidget {
  const BlurryDialogWidget({
    super.key,
    required this.title,
    required this.content,
  });

  final TextStyle textStyle = const TextStyle(color: Colors.black);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: textStyle,
      ),
      content: Text(
        content,
        style: textStyle,
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        ElevatedButton(
          child: const Text("Continue"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
