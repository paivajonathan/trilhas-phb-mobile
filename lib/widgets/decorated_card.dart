import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:trilhas_phb/models/appointment.dart";

class DecoratedCard extends StatelessWidget {
  const DecoratedCard({
    super.key,
    required this.appointment,
    required this.actionText,
    required this.onTap,
    this.isPrimary = true,
  });

  final AppointmentModel appointment;
  final String actionText;
  final bool isPrimary;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    String imageUrl = appointment.hike.images[0];
    String difficulty = appointment.hike.readableDifficulty;
    int difficultyColor = appointment.hike.difficultyColor;
    String title = appointment.hike.name;
    String subtitle = appointment.fullReadableTime;

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
                    color: Color(difficultyColor),
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
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
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
