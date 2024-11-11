import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';

class DecoratedTextFormField extends StatelessWidget {
  const DecoratedTextFormField({
    super.key,
    
    String? initialValue,
    String? hintText,
    TextInputType? textInputType,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) :
    _initialValue = initialValue,
    _hintText = hintText,
    _textInputType = textInputType,
    _controller = controller,
    _validator = validator,
    _onChanged = onChanged;
  
  final String? _initialValue;
  final String? _hintText;
  final TextInputType? _textInputType;
  final TextEditingController? _controller;
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
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: _hintText,
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 194, 194, 194),
        ),
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
      ),
    );
  }
}
