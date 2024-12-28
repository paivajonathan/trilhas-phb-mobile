import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import "package:trilhas_phb/widgets/decorated_button.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import 'package:trilhas_phb/screens/authentication/reset_password/create_new_password.dart';
import 'package:trilhas_phb/services/auth.dart';

class ConfirmationCodeScreen extends StatefulWidget {
  const ConfirmationCodeScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<ConfirmationCodeScreen> createState() => _ConfirmationCodeScreenState();
}

class _ConfirmationCodeScreenState extends State<ConfirmationCodeScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _authService = AuthService();

  Future<void> _handleSubmit(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      // Use o email passado para a tela ao invés do controlador
      await _authService.sendConfirmationCode(email: widget.email);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Código reenviado com sucesso.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _validateCode(String code, BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final message = await _authService.checkConfirmationCode(
        email: widget.email,
        confirmationCode: code,
      );

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      // Navigate to the next screen on successful validation
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateNewPassword(
                  email: widget.email,
                  confirmationCode: code,
                )),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
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
          top: 30.0,
          left: 25.0,
          right: 25.0,
          bottom: 25.0,
        ),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Digite o código de confirmação",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF71727A),
                    ),
                    children: [
                      const TextSpan(
                        text:
                            "Um código de confirmação foi enviado para o email ",
                      ),
                      TextSpan(
                        text: widget.email,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, // Aplica o negrito
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                OtpTextField(
                  numberOfFields: 6,
                  focusedBorderColor: AppColors.primary,
                  cursorColor: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) {
                    _validateCode(verificationCode, context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Código de Verificação"),
                            content:
                                Text('O código digitado foi $verificationCode'),
                          );
                        });
                  }, // end onSubmit
                  inputFormatters: [LengthLimitingTextInputFormatter(1)],
                ),
                const Spacer(),
                InkWell(
                  onTap: () => _handleSubmit(context),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Reenviar Código",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                DecoratedButton(
                    primary: true,
                    text: "Continuar",
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Insira o código e pressione Continuar."),
                        ),
                      );
                    }
                    //isLoading: _isLoading,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
