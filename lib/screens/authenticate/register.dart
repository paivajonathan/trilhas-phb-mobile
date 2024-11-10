import "package:flutter/material.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/services/auth.dart";
import "package:trilhas_phb/screens/authenticate/personal_data.dart";

class RegisterScreen extends StatefulWidget {  
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.primary, //change your color here
        ),
        backgroundColor: AppColors.secondary,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: AppColors.secondary,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite um email.";
                  }

                  return null;
                },
                onChanged: (value) {
                  setState(() => email = value);
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite uma senha.";
                  }

                  if (value.length < 6) {
                    return "Digite uma senha maior do que 6 caracteres";
                  }

                  return null;
                },
                onChanged: (value) {
                  setState(() => password = value);
                },
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Verificar se o formulário é válido
                    if (_formKey.currentState!.validate()) {
                      // Navegar para a próxima tela (Cadastro) e passar os dados de email e senha
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalData(
                            email: email,
                            password: password,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: loading 
                    ? const SizedBox(
                        height: 23.0,
                        width: 23.0,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                          )
                        ),
                      )
                    : const Text(
                        "Continuar",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                )
              ),
              const SizedBox(height: 20),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 20),
              )
            ],
          )
        )
      ),
    );
  }
}