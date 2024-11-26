import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:trilhas_phb/models/appointment.dart";

class DecoratedCard extends StatelessWidget {
  const DecoratedCard({
    super.key,
    required this.appointment,
    required this.actionText,
    this.isPrimary = true,
  });

  final AppointmentModel appointment;
  final String actionText;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    String imageUrl = appointment.hike.images[0];
    
    String difficulty = switch(appointment.hike.difficulty) {
      "H" => "DIFÍCIL",
      "M" => "MÉDIO",
      "E" => "FÁCIL",
      _ => "INVÁLIDO",
    };
    Color difficultyColor = switch(appointment.hike.difficulty) {
      "H" => Colors.red,
      "M" => Colors.yellow,
      "E" => const Color(0xFF00BF63),
      _ => Colors.blue,
    };
    
    String title = appointment.hike.name;

    String day = appointment.datetime.day.toString();
    String month = switch(appointment.datetime.month) {
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
    String time = "${appointment.datetime.hour}:${appointment.datetime.hour}";

    String subtitle = "$day de $month, às $time";

    return Container(
      width: 250,
      height: 250,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Stack(
            children: [
              Image.network(
                imageUrl,
                height: 125,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                height: 125,
                alignment: Alignment.topRight,
                child: Container(
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
                    maxLines: 1,
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            width: double.infinity,
            height: 125,
            color: isPrimary
              ? const Color(0xFFF9F8FE)
              : const Color(0xFF00BF63),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      color: isPrimary
                        ? Colors.black
                        : const Color(0xFFF9F8FE)
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: isPrimary
                        ? Colors.black
                        : const Color(0xFFF9F8FE)
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isPrimary
                        ? null
                        : const Color(0xFFF9F8FE),
                      border: Border.all(
                        width: 1,
                        color: isPrimary
                        ? const Color(0xFF00BF63)
                        : const Color(0xFFF9F8FE),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      actionText,
                      maxLines: 1,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Color(0xFF00BF63),
                      )
                    ),
                  )
                ],
              )
            )
          ),
        ]
      ),
    );
  }
}
