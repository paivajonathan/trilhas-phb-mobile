import "package:flutter/material.dart";
import "package:trilhas_phb/services/auth.dart";

class RegisterScreen extends StatefulWidget {
  final Function toggleView;
  
  const RegisterScreen({
    super.key,
    required this.toggleView,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Sign Up"),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            label: const Text("Sign In"),
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    print("Testando");
                  }
                },
                child: const Text("Register", style: TextStyle(color: Colors.black)),
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