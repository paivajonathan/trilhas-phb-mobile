import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';

class DecoratedButton extends StatelessWidget {
  const DecoratedButton({
    super.key,
    required this.text,
    required this.primary,
    required this.onPressed,
    this.isLoading = false,
    this.color = AppColors.primary,
  });

  final String text;
  final bool primary;
  final bool isLoading;
  final Color color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary
            ? color
            : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: primary
            ? null
            : BorderSide(color: color, width: 1)
        ),
        child: isLoading 
          ? SizedBox(
              height: 23.0,
              width: 23.0,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primary ? Colors.white : color)
                )
              ),
            )
          : Text(
              text,
              style: TextStyle(
                color: primary
                  ?Colors.white
                  : color,
                fontSize: 16,
              ),
            ),
      ),
    );
  }
}
