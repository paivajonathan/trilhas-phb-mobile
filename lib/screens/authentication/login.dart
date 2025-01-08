import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/helpers/validators.dart";
import "package:trilhas_phb/providers/user_data.dart";
import "package:trilhas_phb/screens/authentication/registration/register.dart";
import "package:trilhas_phb/screens/navigation_wrapper.dart";
import "package:trilhas_phb/screens/authentication/reset_password/insert_email.dart";
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

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      final userData = await _auth.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!context.mounted) return;

      final userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      userDataProvider.setUserData(userData);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const NavigationWrapper()),
        (Route<dynamic> route) => false,
      );
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              "Erro no login: ${e.toString().replaceAll("Exception: ", "")}",
            ),
          ),
        );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite um email.";
    }

    if (!isEmailValid(value)) {
      return "Digite um email válido.";
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
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
                      textInputType: TextInputType.emailAddress,
                      hintText: "Email",
                      validator: _validateEmail,
                      controller: _emailController,
                      isHintTextLabel: true,
                    ),
                    const SizedBox(height: 20),
                    DecoratedTextFormField(
                      hintText: "Senha",
                      controller: _passwordController,
                      validator: _validatePassword,
                      isPassword: true,
                      isHintTextLabel: true,
                      onPasswordToggle: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      isPasswordVisible: _isPasswordVisible,
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const InsertEmail(),
                          ),
                        );
                      },
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Esqueceu a senha?",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DecoratedButton(
                      text: "Login",
                      primary: true,
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : () => _login(context),
                    ),
                    const SizedBox(height: 20),
                    DecoratedButton(
                      text: "Criar Conta",
                      primary: false,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Register(),
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
      ),
    );
  }
}
