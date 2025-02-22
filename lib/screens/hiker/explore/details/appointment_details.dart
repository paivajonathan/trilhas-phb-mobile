import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/helpers/map.dart';
import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/services/hike.dart';
import 'package:trilhas_phb/services/participation.dart';
import 'package:trilhas_phb/widgets/alert_dialog.dart';
import 'package:trilhas_phb/widgets/decorated_button.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({
    super.key,
    required AppointmentModel appointment,
  }) : _appointment = appointment;

  final AppointmentModel _appointment;

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Informações",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
      body: Stack(
        children: [
          MapView(appointment: widget._appointment),
          BottomDrawer(appointment: widget._appointment),
        ],
      ),
    );
  }
}

class MapView extends StatelessWidget {
  MapView({
    super.key,
    required AppointmentModel appointment,
  }) : _appointment = appointment;

  final AppointmentModel _appointment;

  final _hikeService = HikeService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _hikeService.loadGpxPoints(gpxFile: _appointment.hike.gpxFile),
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

        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text("Não há dados para mostrar."),
          );
        }

        return FlutterMap(
          options: MapOptions(
            initialCenter: snapshot.data!.last,
            initialZoom: 15.0,
            minZoom: 12.5,
            maxZoom: 17.5,
            cameraConstraint: CameraConstraint.containCenter(
              bounds: calculateBounds(snapshot.data!),
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: snapshot.data!,
                  color: AppColors.primary,
                  strokeWidth: 4.0,
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class BottomDrawer extends StatefulWidget {
  const BottomDrawer({
    super.key,
    required AppointmentModel appointment,
  }) : _appointment = appointment;

  final AppointmentModel _appointment;

  @override
  State<BottomDrawer> createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {
  final _participationService = ParticipationService();
  late bool _doesUserParticipate = widget._appointment.hasUserParticipation;
  bool _isButtonLoading = false;

  final double _maxHeight = 0.7;
  final double _minHeight = 0.075;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _handleParticipation() async {
    try {
      setState(() {
        _isButtonLoading = true;
      });

      if (_doesUserParticipate) {
        final keepAction = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return const DialogWidget(
              title: "Cancelar participação",
              content: "Você realmente deseja cancelar a sua participação?",
              cancelText: "Não",
              continueText: "Cancelar",
              isDestructiveAction: true,
            );
          },
        );

        if (keepAction == null) return;
        if (!keepAction) return;

        await _participationService.cancel(
          appointmentId: widget._appointment.id,
        );

        setState(() {
          _doesUserParticipate = false;
        });

        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text("Participação cancelada com sucesso."),
            ),
          );
      } else {
        await _participationService.create(
          appointmentId: widget._appointment.id,
        );

        setState(() {
          _doesUserParticipate = true;
        });

        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text("Participação registrada com sucesso."),
            ),
          );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      final message = _doesUserParticipate
          ? "Ocorreu um erro ao tentar cancelar a sua participação na trilha."
          : "Ocorreu um erro ao tentar fixar sua participação na trilha.";

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              "$message: ${e.toString().replaceAll("Exception: ", "")}",
            ),
          ),
        );
    } finally {
      setState(() {
        _isButtonLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = widget._appointment.hike.name;
    String length = widget._appointment.hike.readableLength;
    String difficulty = widget._appointment.hike.readableDifficulty;
    String date = widget._appointment.readableDate;
    String time = widget._appointment.readableTime;
    String description = widget._appointment.hike.description;

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
                        itemCount: widget._appointment.hike.images.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final image = widget._appointment.hike.images[index];

                          return FadeInImage.assetNetwork(
                            placeholder: "assets/loading.gif",
                            image: image.url,
                            fit: BoxFit.cover,
                            height: 250,
                            width: double.infinity,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "assets/placeholder.png",
                                fit: BoxFit.cover,
                                height: 250,
                                width: double.infinity,
                              );
                            },
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
                      Text("DISTÂNCIA: $length Km"),
                      Text("DIFICULDADE: $difficulty"),
                      Text("DATA: $date"),
                      Text("HORÁRIO: $time"),
                      const SizedBox(height: 25),
                      const Text("SOBRE"),
                      Text(description),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: DecoratedButton(
                    primary: _doesUserParticipate ? false : true,
                    text: _doesUserParticipate
                        ? "Cancelar Inscrição"
                        : "Participar",
                    color:
                        _doesUserParticipate ? Colors.red : AppColors.primary,
                    onPressed:
                        _isButtonLoading ? null : () => _handleParticipation(),
                    isLoading: _isButtonLoading,
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
