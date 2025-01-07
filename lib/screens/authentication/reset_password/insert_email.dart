import "package:flutter/material.dart";
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
                //validator: _validateEmail,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
                    return "Insira um e-mail válido";
                  }
                  return null;
                },
              ),

              // Para jogar botão no final da tela
              const Spacer(),

              DecoratedButton(
                primary: true,
                text: "Continuar",
                onPressed: () => _handleSubmit(),
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
