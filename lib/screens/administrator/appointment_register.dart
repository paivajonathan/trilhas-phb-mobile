import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:trilhas_phb/models/hike.dart';
import 'package:trilhas_phb/screens/administrator/explore.dart';
import 'package:trilhas_phb/services/appointment.dart';
import 'package:trilhas_phb/widgets/decorated_button.dart';
import 'package:trilhas_phb/widgets/decorated_list_tile.dart';
import 'package:trilhas_phb/widgets/decorated_text_form_field.dart';

class AppointmentRegisterScreen extends StatefulWidget {
  const AppointmentRegisterScreen({super.key, required this.hike});

  final HikeModel hike;

  @override
  State<AppointmentRegisterScreen> createState() =>
      _AppointmentRegisterScreenState();
}

class _AppointmentRegisterScreenState extends State<AppointmentRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  final _appointmentService = AppointmentService();

  final MaskedTextController _dateController = MaskedTextController(
    mask: "00/00/0000",
  );
  final MaskedTextController _timeController = MaskedTextController(
    mask: "00:00",
  );

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      String formattedDate = DateFormat("yyyy-MM-dd").format(
        DateFormat("dd/MM/yyyy").parse(_dateController.text),
      );

      setState(() {
        _isLoading = true;
      });

      await _appointmentService.create(
        hikeId: widget.hike.id,
        date: formattedDate,
        time: _timeController.text,
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Trilha agendada com sucesso!")),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const ExploreScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Erro no cadastro: ${e.toString().replaceAll("Exception: ", "")}",
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) return "Digite a data";

    final result = DateFormat("dd/MM/yyyy").tryParseStrict(value);

    if (result == null) return "Data inválida";

    return null;
  }

  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) return "Digite o horário";

    final result = DateFormat("HH:mm").tryParseStrict(value);

    if (result == null) return "Horário inválido";

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                  "Defina data e hora",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Defina a data e a hora que a trilha ocorrerá",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF71727A),
                  ),
                ),
                const SizedBox(height: 30),
                DecoratedListTile(
                  hike: widget.hike,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                const Text(
                  "Data",
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
                  validator: _validateDate,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Horário",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                DecoratedTextFormField(
                  hintText: "HH:MM",
                  controller: _timeController,
                  textInputType: TextInputType.number,
                  validator: _validateTime,
                ),
                const Spacer(),
                DecoratedButton(
                  primary: true,
                  text: "Salvar",
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : () => _handleSubmit(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
