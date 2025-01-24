import 'package:flutter/material.dart';
import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/models/participation.dart';
import 'package:trilhas_phb/services/participation.dart';
import 'package:trilhas_phb/widgets/future_button.dart';
import 'package:trilhas_phb/widgets/loader.dart';
import 'package:trilhas_phb/widgets/participation_item.dart';

class FrequencyRegisterScreen extends StatefulWidget {
  const FrequencyRegisterScreen({super.key, required this.appointment});

  final AppointmentModel appointment;

  @override
  State<FrequencyRegisterScreen> createState() =>
      _FrequencyRegisterScreenState();
}

class _FrequencyRegisterScreenState extends State<FrequencyRegisterScreen> {
  List<ParticipationModel> _participations = [];
  bool _areParticipationsLoading = false;
  String? _areParticipationsLoadingError;

  final _participationService = ParticipationService();

  Future<void> _loadParticipations() async {
    try {
      setState(() {
        _areParticipationsLoading = true;
      });

      final participations = await _participationService.getAll(
          appointmentId: widget.appointment.id);

      setState(() {
        _participations = participations;
        _areParticipationsLoadingError = null;
      });
    } catch (e) {
      setState(() {
        _participations = [];
        _areParticipationsLoadingError = e.toString();
      });
    } finally {
      setState(() {
        _areParticipationsLoading = false;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_participations.where((p) => p.status == "U").toList().isNotEmpty) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text("Indique a situação de cada participante da trilha."),
          ),
        );
    }

    try {
      await _participationService.makeFrequency(
          appointmentId: widget.appointment.id,
          participations: _participations);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text("Frequência raelizada com sucesso."),
          ),
        );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadParticipations();
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
      body: Builder(builder: (context) {
        if (_areParticipationsLoading) {
          return const Loader();
        }

        if (_areParticipationsLoadingError != null) {
          return Center(child: Text(_areParticipationsLoadingError!));
        }

        if (_participations.isEmpty) {
          return const Center(
              child: Text("Não há participações para esse agendamento."));
        }

        return Column(
          children: [
            for (final (i, p) in _participations.indexed)
              ParticipationItem(
                participation: p,
                confirmAction: () {
                  setState(() {
                    _participations[i] = p.copyWith(status: "P");
                  });
                },
                cancelAction: () {
                  setState(() {
                    _participations[i] = p.copyWith(status: "A");
                  });
                },
              ),
            const Spacer(),
            FutureButton(
              text: "Registrar",
              primary: true,
              future: _handleSubmit,
            ),
          ],
        );
      }),
    );
  }
}
