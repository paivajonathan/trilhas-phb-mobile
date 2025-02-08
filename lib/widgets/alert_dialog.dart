import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';

class DialogWidget extends StatelessWidget {
  const DialogWidget({
    super.key,
    required this.title,
    required this.content,
    this.cancelText = "Cancelar",
    this.continueText = "Continuar",
    this.isDestructiveAction = false,
  });

  final String title;
  final String content;
  final String cancelText;
  final String continueText;
  final bool isDestructiveAction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: DialogButton(
                text: cancelText,
                primary: false,
                color: isDestructiveAction ? AppColors.primary : Colors.red,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DialogButton(
                text: continueText,
                primary: true,
                color: isDestructiveAction ? Colors.red : AppColors.primary,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DialogButton extends StatelessWidget {
  const DialogButton({
    super.key,
    required this.text,
    required this.primary,
    required this.onPressed,
    this.color = AppColors.primary,
  });

  final String text;
  final bool primary;
  final Color color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: primary ? color : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: primary ? null : BorderSide(color: color, width: 1)),
      child: Text(
        text,
        style: TextStyle(
          color: primary ? Colors.white : color,
          fontSize: 16,
        ),
      ),
    );
  }
}
