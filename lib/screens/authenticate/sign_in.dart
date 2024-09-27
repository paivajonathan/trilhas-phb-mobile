import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Image.network(
              "https://images.pexels.com/photos/1578750/pexels-photo-1578750.jpeg?auto=compress&cs=tinysrgb&w=600",
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: Text(
                      'Bem Vindo(a)!',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Email',
                      hintStyle: TextStyle(fontSize: 16),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 138, 138, 138),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 138, 138, 138),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite um email.';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      setState(() => email = value);
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Senha',
                      hintStyle: TextStyle(fontSize: 16),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 138, 138, 138),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 138, 138, 138),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite uma senha.';
                      }

                      if (value.length < 6) {
                        return 'Digite uma senha maior do que 6 caracteres';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      setState(() => password = value);
                    },
                    obscureText: true,
                    obscuringCharacter: '*',
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);

                          if (result == null) {
                            setState(
                                () => error = 'Ocorreu um erro ao fazer login');
                          }
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.toggleView();
                      },
                      child: Text('Criar conta',
                          style: TextStyle(color: AppColors.primary)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(
                          width: 1,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
