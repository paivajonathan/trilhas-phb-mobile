import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import "package:trilhas_phb/widgets/decorated_button.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import 'package:trilhas_phb/screens/authenticate/reset_password/create_new_password.dart';
import 'package:trilhas_phb/screens/authenticate/reset_password/insert_email.dart';

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
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 100.0,
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
                Text(
                  "Um código de confirmação foi enviado para o email ${widget.email}",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF71727A),
                  ),
                  textAlign: TextAlign.center,
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ConfirmationCodeScreen(email: _emailController.text),
                      ),
                    );
                  },
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
                      //=> _handleSubmit(context),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateNewPassword()),
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
