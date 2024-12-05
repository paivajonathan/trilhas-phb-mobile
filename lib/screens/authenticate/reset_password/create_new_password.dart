import "package:flutter/material.dart";
import "package:trilhas_phb/widgets/decorated_button.dart";
import "package:trilhas_phb/widgets/decorated_label.dart";
import "package:trilhas_phb/widgets/decorated_text_form_field.dart";

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({
    super.key,
  });

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  // bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

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
                /*
                isPasswordVisible: _isPasswordVisible,
                onPasswordToggle: () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                },
                onChanged: (value) {
                  setState(() => widget._sharedData["password"] = value);
                },
                validator: _validatePassword,
                */
              ),
              const SizedBox(height: 16),

              // Campo de confirmar a senha
              const DecoratedLabel(content: "Confirme a senha"),
              const SizedBox(height: 8),
              DecoratedTextFormField(
                hintText: "Digite aqui",
                isPassword: true,
                /*
                isPasswordVisible: _isConfirmPasswordVisible,
                onPasswordToggle: () {
                  setState(() =>
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                },
                onChanged: (value) {
                  setState(() => widget._sharedData["confirmPassword"] = value);
                },
                validator: _validateConfirmPassword,
                */
              ),

              // Para jogar botão no final da tela
              const Spacer(),

              DecoratedButton(
                primary: true,
                text: "Continuar",
                onPressed: () {
                  //=> _navigateToPersonalData(context),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateNewPassword()
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
