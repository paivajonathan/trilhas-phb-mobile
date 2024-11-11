import "package:flutter/material.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/screens/authenticate/personal_data.dart";

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
                _buildTextField(
                  label: "Email",
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
                _buildTextField(
                  label: "Senha",
                  isPassword: true,
                  isPasswordVisible: _isPasswordVisible,
                  onPasswordToggle: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
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
                    setState(() {
                      widget._sharedData["password"] = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: "Confirme a senha",
                  isPassword: true,
                  isPasswordVisible: _isConfirmPasswordVisible,
                  onPasswordToggle: () {
                    setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirme sua senha.";
                    }
                    if (value != widget._sharedData["password"]) {
                      return "As senhas não coincidem.";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      widget._sharedData["confirmPassword"] = value;
                    });
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Continuar",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
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
    bool isPasswordVisible = false,
    TextInputType? textInputType,
    Function()? onPasswordToggle,
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
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          cursorColor: AppColors.primary,
          obscureText: isPassword && !isPasswordVisible,
          validator: validator,
          onChanged: onChanged,
          keyboardType: textInputType,
          decoration: InputDecoration(
            hintText: "Digite aqui",
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 194, 194, 194),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary, // Cor da borda quando o campo está em foco
                width: 2,
              ),
            ),
            suffixIcon: isPassword 
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                    color: const Color(0xFF8F9098),
                  ),
                  onPressed: onPasswordToggle,
                )
              : null,
          ),
        ),
      ],
    );
  }
}
