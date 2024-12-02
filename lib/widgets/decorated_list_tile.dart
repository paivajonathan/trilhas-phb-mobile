import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/models/hike.dart';

class DecoratedListTile extends StatelessWidget {
  const DecoratedListTile({
    super.key,
    required this.onTap,
    this.appointment,
    this.hike,
  }) : 
    assert(
      (appointment != null && hike == null) ||
      (appointment == null && hike != null),
      "É necessário um Agendamento ou uma Trilha para esse Widget."
    );

  final void Function() onTap;
  final AppointmentModel? appointment;
  final HikeModel? hike;

  @override
  Widget build(BuildContext context) {
    late String imageUrl;
    late String title;
    late String subtitle;
    late Widget trailing;

    if (appointment != null) {
      String day = appointment!.datetime.day.toString();
      String month = switch(appointment!.datetime.month) {
        DateTime.january => "Janeiro",
        DateTime.february => "Fevereiro",
        DateTime.march => "Março",
        DateTime.april => "Abril",
        DateTime.may => "Maio",
        DateTime.june => "Junho",
        DateTime.july => "Julho",
        DateTime.august => "Agosto",
        DateTime.september => "Setembro",
        DateTime.october => "Outubro",
        DateTime.november => "Novembro",
        DateTime.december => "Dezembro",
        _ => "Inválido",
      };
      String time = "${appointment!.datetime.hour}:${appointment!.datetime.hour}";

      imageUrl = appointment!.hike.images[0];
      title = appointment!.hike.name;
      subtitle = "$day de $month, às $time";
      trailing = const Icon(Icons.chevron_right);
    } else if (hike != null) {
      String difficulty = switch(hike!.difficulty) {
        "H" => "DIFÍCIL",
        "M" => "MÉDIO",
        "E" => "FÁCIL",
        _ => "INVÁLIDO",
      };
      Color difficultyColor = switch(hike!.difficulty) {
        "H" => Colors.red,
        "M" => Colors.yellow,
        "E" => const Color(0xFF00BF63),
        _ => Colors.blue,
      };
      imageUrl = hike!.images[0];
      title = hike!.name;
      subtitle = "Distância: ${hike!.length.toString()}km";
      trailing = Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        width: 64,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: difficultyColor,
        ),
        child: Text(
          difficulty,
          style: GoogleFonts.inter(
            textStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Image.network(
              imageUrl,
              width: 80,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: const Color(0xFFF9F8FE),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            )
                          ),
                          Text(
                            subtitle,
                            maxLines: 1,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    trailing,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
