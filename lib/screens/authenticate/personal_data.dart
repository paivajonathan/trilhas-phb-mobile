import "package:flutter/material.dart";
import "package:flutter_masked_text2/flutter_masked_text2.dart";
import "package:google_fonts/google_fonts.dart";
import "package:trilhas_phb/services/auth.dart";

class PersonalData extends StatefulWidget {
  final String email;
  final String password;

  // Construtor para receber email e senha
  const PersonalData({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  _PersonalDataScreenState createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalData> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String full_name = '';
  String birth_date = '';
  String phone = '';
  String district = '';

   // Variáveis para email e senha
  late String email;
  late String password;

  // Instância do AuthService

  final FocusNode _full_nameFocusNode = FocusNode();
  final FocusNode _birth_dateFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _districtFocusNode = FocusNode();

  Color _nameBorderColor = Colors.grey;
  Color _dateBorderColor = Colors.grey;
  Color _phoneBorderColor = Colors.grey;
  Color _districtBorderColor = Colors.grey;

  MaskedTextController _dateController = MaskedTextController(mask: '00/00/0000');
  MaskedTextController _phoneController = MaskedTextController(mask: '(00)00000-0000');

  @override
  void initState() {
    super.initState();
    // Inicializar email e senha com os valores recebidos
    email = widget.email;
    password = widget.password;

    _full_nameFocusNode.addListener(() {
      setState(() {
        _nameBorderColor = _full_nameFocusNode.hasFocus ? Colors.green : const Color.fromARGB(255, 194, 194, 194);
      });
    });

    _birth_dateFocusNode.addListener(() {
      setState(() {
        _dateBorderColor = _birth_dateFocusNode.hasFocus ? Colors.green : const Color.fromARGB(255, 194, 194, 194);
      });
    });

    _phoneFocusNode.addListener(() {
      setState(() {
        _phoneBorderColor = _phoneFocusNode.hasFocus ? Colors.green : const Color.fromARGB(255, 194, 194, 194);
      });
    });

    _districtFocusNode.addListener(() {
      setState(() {
        _districtBorderColor = _districtFocusNode.hasFocus ? Colors.green : const Color.fromARGB(255, 194, 194, 194);
      });
    });
  }

  @override
  void dispose() {
    _full_nameFocusNode.dispose();
    _birth_dateFocusNode.dispose();
    _phoneFocusNode.dispose();
    _districtFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //Background color dos formulários
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            Text(
              "Dados Pessoais",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5), // Ajusta a posição do subtítulo
            Text(
              "Insira seus dados pessoais abaixo",
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 120
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30), // Ajuste inicial
              // Campo Nome Completo
              Text(
                'Nome Completo',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                cursorColor: Colors.green,
                focusNode: _full_nameFocusNode,
                decoration: InputDecoration(
                  hintText: "Digite aqui",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 194, 194, 194),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: _nameBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: _nameBorderColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu nome';
                  }
                  return null;
                },
                onChanged: (value) => full_name = value,
              ),
              const SizedBox(height: 20),

              // Campo Data de Aniversário
              Text(
                'Data de Aniversário',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                cursorColor: Colors.green,
                focusNode: _birth_dateFocusNode,
                controller: _dateController,
                decoration: InputDecoration(
                  hintText: "DD/MM/AAAA",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 194, 194, 194),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: _dateBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: _dateBorderColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'DD/MM/AAAA';
                  }
                  return null;
                },
                onChanged: (value) => birth_date = value,
              ),
              const SizedBox(height: 20),

              // Campo Número
              Text(
                'Número',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                cursorColor: Colors.green,
                focusNode: _phoneFocusNode,
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: "Digite aqui",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 194, 194, 194),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: _phoneBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: _phoneBorderColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite aqui';
                  }
                  return null;
                },
                onChanged: (value) => phone = value,
              ),
              const SizedBox(height: 20),

              // Campo Bairro (opcional)
              Text(
                'Bairro (opcional)',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                cursorColor: Colors.green,
                focusNode: _districtFocusNode,
                decoration: InputDecoration(
                  hintText: "Digite aqui",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 194, 194, 194),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: _districtBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: _districtBorderColor),
                  ),
                ),
                validator: (value) {
                  return null;
                },
                onChanged: (value) => district = value,
              ),
              const SizedBox(height: 10),
              Spacer(), // Empurra o botão "Continuar" para o fundo

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processando cadastro...')),
                    );
                    
                    // Tenta realizar o cadastro
                    try {
                      final result = await _auth.register(email: email, password: password, fullName: full_name, birthDate: birth_date, cellphone: phone, neighborhoodName: district);
                      if (result != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cadastro realizado com sucesso!')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro no cadastro: $e')),
                      );
                    }
                  }
                },
                child: const Text("Continuar"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: const Color.fromARGB(255, 3, 204, 107),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
