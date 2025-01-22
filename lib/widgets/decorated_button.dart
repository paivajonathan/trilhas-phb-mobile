import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';

class DecoratedButton extends StatelessWidget {
  const DecoratedButton({
    super.key,
    required this.text,
    required this.primary,
    required this.onPressed,
    this.isLoading = false,
  });

  final String text;
  final bool primary;
  final bool isLoading;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary
            ? AppColors.primary
            : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: primary
            ? null
            : const BorderSide(color: AppColors.primary, width: 1)
        ),
        child: isLoading 
          ? const SizedBox(
              height: 23.0,
              width: 23.0,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                )
              ),
            )
          : Text(
              text,
              style: TextStyle(
                color: primary
                  ?Colors.white
                  : AppColors.primary,
                fontSize: 16,
              ),
            ),
      ),
    );
  }
}
