import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/models/participation.dart';
import 'package:trilhas_phb/services/participation.dart';
import 'package:trilhas_phb/widgets/loader.dart';
import 'package:trilhas_phb/widgets/participation_item.dart';
import 'package:trilhas_phb/widgets/title_quantity_trait.dart';

class ParticipationViewScreen extends StatefulWidget {
  const ParticipationViewScreen({
    super.key,
    required this.appointmentId,
  });

  final int appointmentId;

  @override
  State<ParticipationViewScreen> createState() =>
      _ParticipationViewScreenState();
}

class _ParticipationViewScreenState extends State<ParticipationViewScreen> {
  final _participationService = ParticipationService();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Participantes da Trilha",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.black.withOpacity(.25),
              height: 1.0,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: FutureBuilder<List<ParticipationModel>>(
            future: _participationService.getAll(
              appointmentId: widget.appointmentId,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Loader());
              }
          
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar dados: ${snapshot.error!.toString().replaceAll("Exception: ", "")}',
                  ),
                );
              }
          
              final participations = snapshot.data ?? [];
          
              if (participations.isEmpty) {
                return const Center(
                  child: Text(
                    'Não há participantes neste agendamento de trilha.',
                  ),
                );
              }
          
              return ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TitleQuantityTrait(
                        number: participations.length,
                        title: 'Participantes',
                        titleSingular: 'Participante',
                        color: AppColors.primary,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  for (final participation in participations)
                    ParticipationItem(participation: participation)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
