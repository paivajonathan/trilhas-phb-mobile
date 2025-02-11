import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:trilhas_phb/helpers/validators.dart";
import "package:trilhas_phb/widgets/decorated_button.dart";
import "package:trilhas_phb/widgets/decorated_label.dart";
import "package:trilhas_phb/widgets/decorated_text_form_field.dart";
import "package:trilhas_phb/services/auth.dart";
import "package:trilhas_phb/screens/authentication/reset_password/confirmation_code.dart";

class InsertEmail extends StatefulWidget {
  const InsertEmail({
    super.key,
  });

  @override
  State<InsertEmail> createState() => _InsertEmailState();
}

class _InsertEmailState extends State<InsertEmail> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _authService = AuthService();

  final _emailController = TextEditingController();

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        _isLoading = true;
      });

      await _authService.sendConfirmationCode(email: _emailController.text);

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmationCodeScreen(
            email: _emailController.text,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
        );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Insira um e-mail.";
    }

    if (!isEmailValid(value)) {
      return "Insira um e-mail válido.";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                  "Esqueceu a Senha?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Insira seu Email abaixo para redefinir sua senha",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF71727A),
                  ),
                ),
                const SizedBox(height: 30),
      
                // Campo de email
                const DecoratedLabel(content: "Email"),
                const SizedBox(height: 8),
                DecoratedTextFormField(
                  hintText: "Digite aqui",
                  textInputType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: _validateEmail,
                  inputFormatters: [LengthLimitingTextInputFormatter(254)],
                ),
      
                // Para jogar botão no final da tela
                const Spacer(),
      
                DecoratedButton(
                  primary: true,
                  text: "Continuar",
                  onPressed: _isLoading ? null : () => _handleSubmit(),
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
