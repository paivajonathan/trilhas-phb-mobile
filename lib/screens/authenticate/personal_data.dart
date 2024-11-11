import "package:flutter/material.dart";
import "package:flutter_masked_text2/flutter_masked_text2.dart";
import "package:google_fonts/google_fonts.dart";
import "package:trilhas_phb/services/auth.dart";
import "package:intl/intl.dart";

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
  State<PersonalData> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalData> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String fullName = "";
  String birthDate = "";
  String phone = "";
  String district = "";

  // Variáveis para email e senha
  late String email;
  late String password;

  // Instância do AuthService
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _birthDateFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _districtFocusNode = FocusNode();

  Color _fullNameBorderColor = Colors.grey;
  Color _birthDateBorderColor = Colors.grey;
  Color _phoneBorderColor = Colors.grey;
  Color _districtBorderColor = Colors.grey;

  final MaskedTextController _dateController = MaskedTextController(mask: "00/00/0000");
  final MaskedTextController _phoneController = MaskedTextController(mask: "(00)00000-0000");

  @override
  void initState() {
    super.initState();
    
    // Inicializar email e senha com os valores recebidos
    email = widget.email;
    password = widget.password;

    _fullNameFocusNode.addListener(() {
      setState(() {
        _fullNameBorderColor = _fullNameFocusNode.hasFocus
          ?Colors.green
          : const Color.fromARGB(255, 194, 194, 194);
      });
    });

    _birthDateFocusNode.addListener(() {
      setState(() {
        _birthDateBorderColor = _birthDateFocusNode.hasFocus
          ? Colors.green
          : const Color.fromARGB(255, 194, 194, 194);
      });
    });

    _phoneFocusNode.addListener(() {
      setState(() {
        _phoneBorderColor = _phoneFocusNode.hasFocus
          ? Colors.green
          : const Color.fromARGB(255, 194, 194, 194);
      });
    });

    _districtFocusNode.addListener(() {
      setState(() {
        _districtBorderColor = _districtFocusNode.hasFocus
          ? Colors.green
          : const Color.fromARGB(255, 194, 194, 194);
      });
    });
  }

  @override
  void dispose() {
    _fullNameFocusNode.dispose();
    _birthDateFocusNode.dispose();
    _phoneFocusNode.dispose();
    _districtFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //Background color dos formulários
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SizedBox(
            height: 20,
            width: 20,
            child: Image.asset('assets/icon_voltar.png'),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Dados Pessoais",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4), // Ajusta a posição do subtítulo
              const Text(
                "Insira seus dados pessoais abaixo",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF71727A),
                ),
              ),
              const SizedBox(height: 30), // Ajuste inicial
              
              // Campo Nome Completo
              const Text(
                "Nome Completo",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              DecoratedTextFormField(
                focusNode: _fullNameFocusNode,
                borderColor: _fullNameBorderColor,
                hintText: "Digite aqui",
                onChanged: (value) => fullName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite seu nome";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Campo Data de Aniversário
              const Text(
                "Data de Aniversário",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              DecoratedTextFormField(
                focusNode: _birthDateFocusNode,
                borderColor: _birthDateBorderColor,
                hintText: "DD/MM/AAAA",
                controller: _dateController,
                onChanged: (value) => birthDate = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite sua data de aniversário";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Campo Número
              const Text(
                "Número",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              DecoratedTextFormField(
                focusNode: _phoneFocusNode,
                borderColor: _phoneBorderColor,
                controller: _phoneController,
                hintText: "Digite aqui",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite seu número";
                  }

                  return null;
                },
                onChanged: (value) => phone = value,
              ),
              const SizedBox(height: 16),
              
              // Campo Bairro (opcional)
              const Text(
                "Bairro (opcional)",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              DecoratedTextFormField(
                focusNode: _districtFocusNode,
                borderColor: _districtBorderColor,
                hintText: "Digite aqui",
                validator: (value) => null,
                onChanged: (value) => district = value,
              ),
              
              const Spacer(), // Empurra o botão "Continuar" para o fundo
              
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Processando cadastro...")),
                  );

                  String unmaskedPhone = phone.replaceAll(RegExp(r"[^0-9]"), "");
                  
                  DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(birthDate);
                  String formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);
                  
                  try {
                    await _auth.register(
                      email: email,
                      password: password,
                      fullName: fullName,
                      birthDate: formattedDate,
                      cellphone: unmaskedPhone,
                      neighborhoodName: district,
                    );
                  
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Cadastro realizado com sucesso!")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erro no cadastro: ${e.toString().replaceAll("Exception: ", "")}")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: const Color.fromARGB(255, 3, 204, 107),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Continuar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DecoratedTextFormField extends StatelessWidget {
  const DecoratedTextFormField({
    super.key,
    
    required FocusNode focusNode,
    required Color borderColor,
    
    String? hintText,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) :
    _focusNode = focusNode,
    _borderColor = borderColor,
    _hintText = hintText,
    _controller = controller,
    _validator = validator,
    _onChanged = onChanged;

  final FocusNode _focusNode;
  final Color _borderColor;
  
  final String? _hintText;
  final TextEditingController? _controller;
  final String? Function(String?)? _validator;
  final void Function(String)? _onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.green,
      focusNode: _focusNode,
      controller: _controller,
      validator: _validator,
      onChanged: _onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: _hintText,
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 194, 194, 194),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _borderColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _borderColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
