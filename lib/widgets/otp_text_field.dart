import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnCodeEnteredCompletion = void Function(String value);
typedef OnCodeChanged = void Function(String value);
typedef HandleControllers = void Function(
    List<TextEditingController?> controllers);

// ignore: must_be_immutable
class OtpTextField extends StatefulWidget {
  final bool showCursor;
  final int numberOfFields;
  final double fieldWidth;
  final double? fieldHeight;
  final double borderWidth;
  final Alignment? alignment;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final Color disabledBorderColor;
  final Color borderColor;
  final Color? cursorColor;
  final EdgeInsetsGeometry margin;
  final TextInputType keyboardType;
  final TextStyle? textStyle;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final OnCodeEnteredCompletion? onSubmit;
  final OnCodeEnteredCompletion? onCodeChanged;
  final HandleControllers? handleControllers;
  final bool obscureText;
  final bool showFieldAsBox;
  final bool enabled;
  final bool filled;
  final bool autoFocus;
  final bool readOnly;
  bool clearText;
  final bool hasCustomInputDecoration;
  final Color fillColor;
  final BorderRadius borderRadius;
  final InputDecoration? decoration;
  final List<TextStyle?> styles;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;

  OtpTextField({
    this.showCursor = true,
    this.numberOfFields = 4,
    this.fieldWidth = 40.0,
    this.fieldHeight,
    this.alignment,
    this.margin = const EdgeInsets.only(right: 8.0),
    this.textStyle,
    this.clearText = false,
    this.styles = const [],
    this.keyboardType = TextInputType.number,
    this.borderWidth = 2.0,
    this.cursorColor,
    this.disabledBorderColor = const Color(0xFFE7E7E7),
    this.enabledBorderColor = const Color(0xFFE7E7E7),
    this.borderColor = const Color(0xFFE7E7E7),
    this.focusedBorderColor = const Color(0xFF4F44FF),
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.handleControllers,
    this.onSubmit,
    this.obscureText = false,
    this.showFieldAsBox = false,
    this.enabled = true,
    this.autoFocus = false,
    this.hasCustomInputDecoration = false,
    this.filled = false,
    this.fillColor = const Color(0xFFFFFFFF),
    this.readOnly = false,
    this.decoration,
    this.onCodeChanged,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.inputFormatters,
    this.contentPadding,
  })  : assert(numberOfFields > 0),
        assert(styles.length > 0
            ? styles.length == numberOfFields
            : styles.length == 0);

  @override
  _OtpTextFieldState createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  late List<String?> _verificationCode;
  late List<FocusNode?> _focusNodes;
  late List<TextEditingController?> _textControllers;

  @override
  void initState() {
    super.initState();

    _verificationCode = List<String?>.filled(widget.numberOfFields, null);
    _focusNodes = List<FocusNode?>.filled(widget.numberOfFields, null);
    _textControllers = List<TextEditingController?>.filled(
      widget.numberOfFields,
      null,
    );
  }

  @override
  void didUpdateWidget(covariant OtpTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.clearText != widget.clearText && widget.clearText == true) {
      for (var controller in _textControllers) {
        controller?.clear();
      }
      _verificationCode = List<String?>.filled(widget.numberOfFields, null);
      setState(() {
        widget.clearText = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textControllers
        .forEach((TextEditingController? controller) => controller?.dispose());
  }

  @override
  Widget build(BuildContext context) {
    // Listens for backspace key event when textfield is empty. Moves to previous node if possible.
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (value) {
        if (value.logicalKey.keyLabel == 'Backspace') {
          changeFocusToPreviousNodeWhenTapBackspace();
        }
      },
      child: generateTextFields(context),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required int index,
    TextStyle? style,
  }) {
    return Container(
      width: widget.fieldWidth,
      height: widget.fieldHeight,
      alignment: widget.alignment,
      margin: widget.margin,
      child: Stack(
        children: [
          // TextFormField remains as the base widget
          TextFormField(
            showCursor: widget.showCursor,
            keyboardType: widget.keyboardType,
            textAlign: TextAlign.center,
            maxLength: 1,
            readOnly: widget.readOnly,
            style: style ?? widget.textStyle,
            autofocus: widget.autoFocus && index == 0,
            cursorColor: widget.cursorColor,
            controller: _textControllers[index],
            focusNode: _focusNodes[index],
            enabled: widget.enabled,
            inputFormatters: widget.inputFormatters ??
                [FilteringTextInputFormatter.digitsOnly],
            decoration: widget.hasCustomInputDecoration
                ? widget.decoration
                : InputDecoration(
                    counterText: "",
                    filled: widget.filled,
                    fillColor: widget.fillColor,
                    focusedBorder: widget.showFieldAsBox
                        ? outlineBorder(widget.focusedBorderColor)
                        : underlineInputBorder(widget.focusedBorderColor),
                    enabledBorder: widget.showFieldAsBox
                        ? outlineBorder(widget.enabledBorderColor)
                        : underlineInputBorder(widget.enabledBorderColor),
                    disabledBorder: widget.showFieldAsBox
                        ? outlineBorder(widget.disabledBorderColor)
                        : underlineInputBorder(widget.disabledBorderColor),
                    border: widget.showFieldAsBox
                        ? outlineBorder(widget.borderColor)
                        : underlineInputBorder(widget.borderColor),
                    contentPadding: widget.contentPadding,
                  ),
            obscureText: widget.obscureText,
            onChanged: (String value) {
              if (value.length == 1) {
                // Move focus to the next field
                changeFocusToNextNodeWhenValueIsEntered(
                  value: value,
                  indexOfTextField: index,
                );
              } else if (value.isEmpty) {
                // Move focus to the previous field
                changeFocusToPreviousNodeWhenValueIsRemoved(
                  value: value,
                  indexOfTextField: index,
                );
              }
              _verificationCode[index] = value;
              onCodeChanged(verificationCode: _verificationCode);
              onSubmit(verificationCode: _verificationCode);
            },
          ),
          // GestureDetector overlay to intercept taps
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                final firstEmptyIndex = _textControllers.indexWhere(
                    (controller) =>
                        controller == null || controller.text.isEmpty);
                if (firstEmptyIndex != -1) {
                  FocusScope.of(context)
                      .requestFocus(_focusNodes[firstEmptyIndex]);
                } else {
                  FocusScope.of(context)
                      .requestFocus(_focusNodes[_focusNodes.length - 1]);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder outlineBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: widget.borderWidth,
        color: color,
      ),
      borderRadius: widget.borderRadius,
    );
  }

  UnderlineInputBorder underlineInputBorder(Color color) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: widget.borderWidth,
      ),
    );
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.numberOfFields, (int i) {
      addFocusNodeToEachTextField(index: i);
      addTextEditingControllerToEachTextField(index: i);

      if (widget.styles.length > 0) {
        return _buildTextField(
          context: context,
          index: i,
          style: widget.styles[i],
        );
      }
      if (widget.handleControllers != null) {
        widget.handleControllers!(_textControllers);
      }
      return _buildTextField(context: context, index: i);
    });

    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: textFields,
    );
  }

  void addFocusNodeToEachTextField({required int index}) {
    if (_focusNodes[index] == null) {
      _focusNodes[index] = FocusNode();
    }
  }

  void addTextEditingControllerToEachTextField({required int index}) {
    if (_textControllers[index] == null) {
      _textControllers[index] = TextEditingController();
    }
  }

  void changeFocusToNextNodeWhenValueIsEntered({
    required String value,
    required int indexOfTextField,
  }) {
    //only change focus to the next textField if the value entered has a length greater than one
    if (value.length > 0) {
      //if the textField in focus is not the last textField,
      // change focus to the next textField
      if (indexOfTextField + 1 != widget.numberOfFields) {
        //change focus to the next textField
        FocusScope.of(context).requestFocus(_focusNodes[indexOfTextField + 1]);
      } else {
        //if the textField in focus is the last textField, unFocus after text changed
        _focusNodes[indexOfTextField]?.unfocus();
      }
    }
  }

  // A flag to eliminate race condition between [changeFocusToPreviousNodeWhenValueIsRemoved] and [changeFocusToPreviousNodeWhenTapBackspace]
  bool _backspaceHandled = false;

  void changeFocusToPreviousNodeWhenValueIsRemoved({
    required String value,
    required int indexOfTextField,
  }) {
    // Race condition eliminator
    _backspaceHandled = true;
    Future.delayed(
      Duration(milliseconds: 100),
      () {
        _backspaceHandled = false;
      },
    );
    //only change focus to the previous textField if the value entered has a length zero
    if (value.length == 0) {
      //if the textField in focus is not the first textField,
      // change focus to the previous textField
      if (indexOfTextField != 0) {
        //change focus to the next textField
        FocusScope.of(context).requestFocus(_focusNodes[indexOfTextField - 1]);
      }
    }
  }

  void changeFocusToPreviousNodeWhenTapBackspace() async {
    // Wait because this is running before [changeFocusToPreviousNodeWhenValueIsRemoved]
    await Future.delayed(Duration(milliseconds: 50));
    if (_backspaceHandled) return;
    final lastFullIndex = _textControllers.lastIndexWhere(
        (controller) => controller != null && controller.text.isNotEmpty);
    if (lastFullIndex != -1) {
      FocusScope.of(context).requestFocus(_focusNodes[lastFullIndex]);
    } else {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    }
  }

  void onSubmit({required List<String?> verificationCode}) {
    if (verificationCode.every((String? code) => code != null && code != '')) {
      if (widget.onSubmit != null) {
        widget.onSubmit!(verificationCode.join());
      }
    }
  }

  void onCodeChanged({required List<String?> verificationCode}) {
    if (widget.onCodeChanged != null) {
      widget.onCodeChanged!(verificationCode.nonNulls.toList().join());
    }
  }

  // void _handlePaste(String str) {
  //   if (str.length > widget.numberOfFields) {
  //     str = str.substring(0, widget.numberOfFields);
  //   }

  //   for (int i = 0; i < str.length; i++) {
  //     String digit = str.substring(i, i + 1);
  //     _textControllers[i]!.text = digit;
  //     _textControllers[i]!.value = TextEditingValue(text: digit);
  //     _verificationCode[i] = digit;
  //   }

  //   FocusScope.of(context).requestFocus(_focusNodes[widget.numberOfFields - 1]);
  //   setState(() {});
  // }
}
