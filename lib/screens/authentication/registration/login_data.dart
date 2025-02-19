import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:trilhas_phb/helpers/validators.dart";
import "package:trilhas_phb/screens/authentication/registration/personal_data.dart";
import "package:trilhas_phb/widgets/decorated_button.dart";
import "package:trilhas_phb/widgets/decorated_label.dart";
import "package:trilhas_phb/widgets/decorated_text_form_field.dart";

class LoginData extends StatefulWidget{
  const LoginData({
    super.key,
    required Map<String, dynamic> sharedData
  }) : _sharedData = sharedData;

  final Map<String, dynamic> _sharedData;

  @override
  State<LoginData> createState() => _LoginDataState();
}

class _LoginDataState extends State<LoginData> {
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite um email.";
    }

    if (!isEmailValid(value)) {
      return "Email inválido.";
    }
    
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite uma senha.";
    }
    
    if (value.length < 6) {
      return "Digite uma senha maior do que 6 caracteres.";
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirme sua senha.";
    }

    if (value != widget._sharedData["password"]) {
      return "As senhas não coincidem.";
    }

    return null;
  }

  void _navigateToPersonalData(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    
    if (!context.mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PersonalData(
          sharedData: widget._sharedData,
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
              child: ListView(
                children: [
                  const Text(
                    "Dados de Login",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Insira seus dados de login abaixo",
                    style: TextStyle(
                      fontSize: 16,
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
                    validator: _validateEmail,
                    inputFormatters: [LengthLimitingTextInputFormatter(254)],
                    onChanged: (value) {
                      setState(() => widget._sharedData["email"] = value);
                    },
                  ),
                  const SizedBox(height: 16),
      
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
                    onChanged: (value) {
                      setState(() => widget._sharedData["password"] = value);
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
                      setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                    },
                    onChanged: (value) {
                      setState(() => widget._sharedData["confirmPassword"] = value);
                    },
                    validator: _validateConfirmPassword,
                  ),

                  const SizedBox(height: 50),
                  DecoratedButton(
                    key: const ValueKey("logindatascreen_continuebutton"),
                    primary: true,
                    text: "Continuar",
                    onPressed: () => _navigateToPersonalData(context),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
}
