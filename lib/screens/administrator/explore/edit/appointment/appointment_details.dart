import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/screens/administrator/explore/edit/appointment/appointment_edit.dart';
import 'package:trilhas_phb/services/appointment.dart';
import 'package:trilhas_phb/widgets/alert_dialog.dart';
import 'package:trilhas_phb/widgets/decorated_button.dart';
import 'package:trilhas_phb/widgets/future_button.dart';
import 'package:trilhas_phb/widgets/map_view.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({
    super.key,
    required this.appointmentId,
  });

  final int appointmentId;

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  final _appointmentService = AppointmentService();
  bool wasEdited = false;

  void _reloadScreen() {
    if (!mounted) return;

    setState(() {
      wasEdited = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Informações",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SizedBox(
            height: 20,
            width: 20,
            child: Image.asset("assets/icon_voltar.png"),
          ),
          onPressed: () {
            Navigator.of(context).pop(wasEdited);
          },
        ),
      ),
      body: FutureBuilder(
        future: _appointmentService.getOne(appointmentId: widget.appointmentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error!.toString()),
            );
          }

          if (snapshot.data == null) {
            return const Center(
              child: Text("Não há dados para mostrar."),
            );
          }

          return Stack(
            children: [
              MapView(appointment: snapshot.data!),
              BottomDrawer(
                appointment: snapshot.data!,
                onUpdate: _reloadScreen,
              ),
            ],
          );
        },
      ),
    );
  }
}

class BottomDrawer extends StatefulWidget {
  const BottomDrawer({
    super.key,
    required this.appointment,
    required this.onUpdate,
  });

  final AppointmentModel appointment;
  final void Function() onUpdate;

  @override
  State<BottomDrawer> createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {
  final double _maxHeight = 0.7;
  final double _minHeight = 0.075;

  final _appointmentService = AppointmentService();

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;

    super.setState(fn);
  }

  Future<void> _handleInactivate() async {
    final keepAction = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const BlurryDialogWidget(
          title: "Deseja continuar?",
          content: "Tem certeza de que deseja continuar?",
        );
      },
    );

    if (keepAction == null) return;
    if (!keepAction) return;

    try {
      await _appointmentService.inactivate(
        appointmentId: widget.appointment.id,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(content: Text("Agendamento inativado com sucesso!")),
        );

      Navigator.of(context).pop(true);
    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "");

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(content: Text(message)),
        );
    }
  }

  Future<void> _handleEdit() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return AppointmentEditScreen(
            appointment: widget.appointment,
          );
        },
      ),
    ).then((value) {
      if (value == null) return;
      if (value) widget.onUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.appointment.hike.name;
    String length = widget.appointment.hike.length.toString();
    String difficulty = widget.appointment.hike.readableDifficulty;
    String date = widget.appointment.readableDate;
    String time = widget.appointment.readableTime;
    String description = widget.appointment.hike.description;

    return DraggableScrollableSheet(
      minChildSize: _minHeight,
      maxChildSize: _maxHeight,
      initialChildSize: _maxHeight,
      snapSizes: [_minHeight, _maxHeight],
      snap: true,
      builder: (_, controller) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 250,
                      child: PageView.builder(
                        itemCount: widget.appointment.hike.images.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final image = widget.appointment.hike.images[index];

                          return Stack(
                            children: [
                              FadeInImage.assetNetwork(
                                placeholder: "assets/loading.gif",
                                image: image.url,
                                fit: BoxFit.cover,
                                height: 250,
                                width: double.infinity,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/placeholder.png",
                                    fit: BoxFit.cover,
                                    height: 250,
                                    width: double.infinity,
                                  );
                                },
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  color: Colors.black.withOpacity(.25),
                                  width: double.infinity,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Container(
                        width: 100.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 25),
                      Text("DISTÂNCIA: $length"),
                      Text("DIFICULDADE: $difficulty"),
                      Text("DATA: $date"),
                      Text("HORÁRIO: $time"),
                      const SizedBox(height: 25),
                      const Text("Sobre"),
                      Text(description),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: DecoratedButton(
                          primary: true,
                          text: "EDITAR",
                          onPressed: () => _handleEdit(),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: FutureButton(
                          primary: false,
                          text: "INATIVAR",
                          future: _handleInactivate,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
