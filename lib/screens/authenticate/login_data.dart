import "package:flutter/material.dart";
import "package:trilhas_phb/screens/authenticate/personal_data.dart";
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Digite um email.";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      widget._sharedData["email"] = value;
                    });
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Digite uma senha.";
                    }
                    if (value.length < 6) {
                      return "Digite uma senha maior do que 6 caracteres";
                    }
                    return null;
                  }
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirme sua senha.";
                    }
                    if (value != widget._sharedData["password"]) {
                      return "As senhas não coincidem.";
                    }
                    return null;
                  }
                ),
                
                // Para jogar botão no final da tela
                const Spacer(),
                
                DecoratedButton(
                  primary: true,
                  text: "Continuar",
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    
                    if (!context.mounted) return;

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PersonalData(
                          sharedData: widget._sharedData,
                        )
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
      ),
    );
  }
}
