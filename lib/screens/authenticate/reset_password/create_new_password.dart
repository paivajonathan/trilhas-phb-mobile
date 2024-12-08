import "package:flutter/material.dart";
import "package:trilhas_phb/widgets/decorated_button.dart";
import "package:trilhas_phb/widgets/decorated_label.dart";
import "package:trilhas_phb/widgets/decorated_text_form_field.dart";
import 'package:trilhas_phb/services/auth.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({
    super.key,
    required this.email,
    required this.confirmationCode,
  });

  final String email;
  final String confirmationCode;

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _passwordController = TextEditingController();

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final message = await _authService.changePassword(
        email: widget.email,
        confirmationCode: widget.confirmationCode,
        newPassword: _passwordController.text,
      );

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

      Navigator.pop(context); // Retorna para a tela anterior
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "A senha não pode estar vazia";
    }
    if (value.length < 6) {
      return "A senha deve ter pelo menos 6 caracteres";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return "As senhas não correspondem";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SizedBox(
            height: 20,
            width: 20,
            child: Image.asset("assets/icon_voltar.png"),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          left: 25.0,
          right: 25.0,
          bottom: 25.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Crie uma nova senha",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Insira sua nova senha abaixo",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF71727A),
                ),
              ),
              const SizedBox(height: 30),

              // Campo de senha
              const DecoratedLabel(content: "Senha"),
              const SizedBox(height: 8),
              DecoratedTextFormField(
                hintText: "Digite aqui",
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onPasswordToggle: () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                },
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),

              // Campo de confirmar a senha
              const DecoratedLabel(content: "Confirme a senha"),
              const SizedBox(height: 8),
              DecoratedTextFormField(
                hintText: "Digite aqui",
                isPassword: true,
                isPasswordVisible: _isConfirmPasswordVisible,
                onPasswordToggle: () {
                  setState(() =>
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                },
                validator: _validateConfirmPassword,
              ),

              // Para jogar botão no final da tela
              const Spacer(),

              DecoratedButton(
                primary: true,
                text: "Continuar",
                onPressed: _isLoading ? null : _changePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
