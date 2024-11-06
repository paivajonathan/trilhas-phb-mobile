import "package:flutter/material.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/services/auth.dart";

class LoginData extends StatefulWidget{
  const LoginData({super.key});

  @override
  State<LoginData> createState() => _LoginDataState();
}

class _LoginDataState extends State<LoginData> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String confirmPassword = "";
  String error = "";

  bool loading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.primary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dados de Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Insira seus dados de login abaixo',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                label: 'Email',
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
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Senha',
                isPassword: true,
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
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Confirme a senha',
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Confirme sua senha.";
                  }
                  if (value != password) {
                    return "As senhas não coincidem.";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() => confirmPassword = value);
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Ação para autenticação ou próximo passo
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    bool isPassword = false,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: isPassword && !_isPasswordVisible,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Digite aqui',
            suffixIcon: isPassword 
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
