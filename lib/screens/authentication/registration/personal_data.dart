import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_masked_text2/flutter_masked_text2.dart";
import "package:trilhas_phb/helpers/calculators.dart";
import "package:trilhas_phb/screens/authentication/login.dart";
import "package:trilhas_phb/services/auth.dart";
import "package:intl/intl.dart";
import "package:trilhas_phb/widgets/decorated_button.dart";
import "package:trilhas_phb/widgets/decorated_text_form_field.dart";

class PersonalData extends StatefulWidget {
  const PersonalData({
    super.key,
    required Map<String, dynamic> sharedData,
  }) : _sharedData = sharedData;

  final Map<String, dynamic> _sharedData;

  @override
  State<PersonalData> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalData> {
  // Instância do AuthService
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  late MaskedTextController _dateController;
  late MaskedTextController _phoneController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _dateController = MaskedTextController(
      text: widget._sharedData["birthDate"],
      mask: "00/00/0000",
    );

    _phoneController = MaskedTextController(
      text: widget._sharedData["phone"],
      mask: "(00) 0 0000-0000",
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      String unmaskedPhone =
          widget._sharedData["phone"].replaceAll(RegExp(r"[^0-9]"), "");

      DateTime parsedDate =
          DateFormat("dd/MM/yyyy").parse(widget._sharedData["birthDate"]);
      String formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      setState(() => _isLoading = true);

      await _auth.register(
        email: widget._sharedData["email"],
        password: widget._sharedData["password"],
        fullName: widget._sharedData["fullName"],
        birthDate: formattedDate,
        cellphone: unmaskedPhone,
        neighborhoodName: widget._sharedData["neighborhoodName"],
      );

      setState(() => _isLoading = false);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(content: Text("Cadastro realizado com sucesso!")),
        );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              "Erro no cadastro: ${e.toString().replaceAll("Exception: ", "")}",
            ),
          ),
        );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite seu nome completo.";
    }

    return null;
  }

  String? _validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite sua data de aniversário.";
    }

    final desiredDate = DateFormat("dd/MM/yyyy").tryParseStrict(value);

    if (desiredDate == null) {
      return "Data inválida.";
    }

    if (desiredDate.year < 1900) {
      return "Data inválida.";
    }

    if (calculateAge(desiredDate) < 18) {
      return "Você deve ser maior de 18 anos para participar.";
    }

    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite seu número de celular.";
    }

    final cleanedValue = value.replaceAll(RegExp(r"[^0-9]"), "");

    if (cleanedValue.length != 11) {
      return "Número de celular deve conter 11 caracteres.";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white, //Background color dos formulários
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
            child: ListView(
              key: ValueKey("listview"),
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
                  initialValue: widget._sharedData["fullName"],
                  hintText: "Digite aqui",
                  inputFormatters: [LengthLimitingTextInputFormatter(150)],
                  onChanged: (value) {
                    widget._sharedData["fullName"] = value;
                  },
                  validator: _validateFullName,
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
                  hintText: "DD/MM/AAAA",
                  controller: _dateController,
                  textInputType: TextInputType.number,
                  onChanged: (value) {
                    widget._sharedData["birthDate"] = value;
                  },
                  validator: _validateBirthDate,
                ),
                const SizedBox(height: 16),

                // Campo Número
                const Text(
                  "Contato",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                DecoratedTextFormField(
                  hintText: "Digite aqui",
                  controller: _phoneController,
                  textInputType: TextInputType.number,
                  validator: _validatePhone,
                  onChanged: (value) {
                    widget._sharedData["phone"] = value;
                  },
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
                  initialValue: widget._sharedData["neighborhoodName"],
                  hintText: "Digite aqui",
                  inputFormatters: [LengthLimitingTextInputFormatter(150)],
                  onChanged: (value) {
                    widget._sharedData["neighborhoodName"] = value;
                  },
                ),

                const SizedBox(height: 50),
                DecoratedButton(
                  key: ValueKey("personaldatascreen_registerbutton"),
                  primary: true,
                  text: "Cadastrar-se",
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : () => _register(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
