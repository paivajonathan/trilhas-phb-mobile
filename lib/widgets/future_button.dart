import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';

class FutureButton extends StatefulWidget {
  const FutureButton({
    super.key,
    required this.text,
    required this.primary,
    required this.future,
    this.color = AppColors.primary,
  });

  final String text;
  final bool primary;
  final Color color;
  final Future<void> Function() future;

  @override
  State<FutureButton> createState() => _FutureButtonState();
}

class _FutureButtonState extends State<FutureButton> {
  bool _isLoading = false;

  Future<void> _handleOnPressed() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await widget.future();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : () => _handleOnPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.primary
            ? widget.color
            : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: widget.primary
            ? null
            : BorderSide(color: widget.color, width: 1)
        ),
        child: _isLoading 
          ? SizedBox(
              height: 23.0,
              width: 23.0,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(widget.primary ? Colors.white : widget.color)
                )
              ),
            )
          : Text(
              widget.text,
              style: TextStyle(
                color: widget.primary
                  ?Colors.white
                  : widget.color,
                fontSize: 16,
              ),
            ),
      ),
    );
  }
}
