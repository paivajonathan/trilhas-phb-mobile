import "package:flutter/material.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/screens/authenticate/register.dart";
import "package:trilhas_phb/screens/main.dart";
import "package:trilhas_phb/services/auth.dart";
import "package:trilhas_phb/widgets/decorated_button.dart";
import "package:trilhas_phb/widgets/decorated_text_form_field.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";
  bool _isLoading = false;

  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);
      
      final userData = await _auth.login(
        email: _email,
        password: _password,
      );

      setState(() => _isLoading = false);
        
      if (!context.mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainScreen(userData: userData)),
        (Route<dynamic> route) => false,
      );
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro no login: ${e.toString().replaceAll("Exception: ", "")}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite um email.";
    }

    return null;                 
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite uma senha.";
    }

    if (value.length < 6) {
      return "Digite uma senha maior do que 6 caracteres";
    }

    return null;
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Image.asset("assets/hikes.jpeg"),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: const Text(
                      "Bem Vindo(a)!",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DecoratedTextFormField(
                    hintText: "Email",
                    validator: _validateEmail,
                    onChanged: (value) {
                      setState(() => _email = value);
                    },
                    isHintTextLabel: true,
                  ),
                  const SizedBox(height: 20),
                  DecoratedTextFormField(
                    hintText: "Senha",
                    onChanged: (value) {
                      setState(() => _password = value);
                    },
                    validator: _validatePassword,
                    obscureText: true,
                    isHintTextLabel: true,
                  ),
                  const SizedBox(height: 20),
                  DecoratedButton(
                    text: "Login",
                    primary: true,
                    isLoading: _isLoading,
                    onPressed: () => _login(context),
                  ),
                  const SizedBox(height: 20),
                  DecoratedButton(
                    text: "Criar Conta",
                    primary: false,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Register()
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
