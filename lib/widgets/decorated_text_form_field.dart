import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trilhas_phb/constants/app_colors.dart';

class DecoratedTextFormField extends StatelessWidget {
  const DecoratedTextFormField({
    super.key,
    
    int maxLines = 1,
    bool isPassword = false,
    bool isPasswordVisible = false,
    bool isHintTextLabel = false,
    String? initialValue,
    String? hintText,
    TextInputType? textInputType,
    List<TextInputFormatter>? inputFormatters,
    TextEditingController? controller,
    Function()? onPasswordToggle,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) :
    _maxLines = maxLines,
    _isHintTextLabel = isHintTextLabel,
    _isPasswordVisible = isPasswordVisible,
    _isPassword = isPassword,
    _initialValue = initialValue,
    _hintText = hintText,
    _textInputType = textInputType,
    _inputFormatters = inputFormatters,
    _controller = controller,
    _onPasswordToggle = onPasswordToggle,
    _validator = validator,
    _onChanged = onChanged;
  
  final int _maxLines;
  final bool _isHintTextLabel;
  final bool _isPassword;
  final bool _isPasswordVisible;
  final String? _initialValue;
  final String? _hintText;
  final TextInputType? _textInputType;
  final List<TextInputFormatter>? _inputFormatters;
  final TextEditingController? _controller;
  final void Function()? _onPasswordToggle;
  final String? Function(String?)? _validator;
  final void Function(String)? _onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.green,
      controller: _controller,
      validator: _validator,
      onChanged: _onChanged,
      initialValue: _initialValue,
      keyboardType: _textInputType,
      inputFormatters: _inputFormatters,
      maxLines: _maxLines,
      obscureText: _isPassword && !_isPasswordVisible,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: _hintText,
        hintStyle: _isHintTextLabel
          ? const TextStyle(fontSize: 16)
          : const TextStyle(fontSize: 16, color: Color.fromARGB(255, 194, 194, 194)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        suffixIcon: _isPassword 
          ? IconButton(
              icon: Icon(
                _isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
                color: const Color(0xFF8F9098),
              ),
              onPressed: _onPasswordToggle,
            )
          : null,
      ),
    );
  }
}
