import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';

class DecoratedButton extends StatelessWidget {
  const DecoratedButton({
    super.key,
    required bool primary,
    required String text,
    required void Function()? onPressed,
    bool isLoading = false,
  }) :
    _text = text,
    _primary = primary,
    _isLoading = isLoading,
    _onPressed = onPressed;

  final String _text;
  final bool _primary;
  final bool _isLoading;
  final void Function()? _onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary
            ? AppColors.primary
            : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: _primary
            ? null
            : const BorderSide(color: AppColors.primary, width: 1)
        ),
        child: _isLoading 
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
              _text,
              style: TextStyle(
                color: _primary
                  ?Colors.white
                  : AppColors.primary,
                fontSize: 16,
              ),
            ),
      ),
    );
  }
}
