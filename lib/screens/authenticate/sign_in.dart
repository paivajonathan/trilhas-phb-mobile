import 'package:flutter/material.dart';
import 'package:trilhas_phb/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  
  const SignIn({
    super.key,
    required this.toggleView
  });

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
      backgroundColor: Color.fromARGB(96, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Login', style: TextStyle(color: Colors.white),),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            label: Text('Register'),
            icon: Icon(Icons.person),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.network("https://images.pexels.com/photos/1578750/pexels-photo-1578750.jpeg?auto=compress&cs=tinysrgb&w=600"),
              SizedBox(height: 20),
              Text('Bem Vindo(a)!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Email'
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
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Senha'
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
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);

                    if (result == null) {
                      setState(() => error = 'Ocorreu um erro ao fazer login');
                    }
                  }
                },
                child: Text('Login', style: TextStyle(color: Colors.black)),
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