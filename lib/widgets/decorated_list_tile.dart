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
  }) : assert(
            (appointment != null && hike == null) ||
                (appointment == null && hike != null),
            "É necessário um Agendamento ou uma Trilha para esse Widget.");

  final void Function() onTap;
  final AppointmentModel? appointment;
  final HikeModel? hike;

  @override
  Widget build(BuildContext context) {
    late String title;
    late String subtitle;
    late String imageUrl;
    late Widget trailing;

    if (appointment != null) {
      title = appointment!.hike.name;
      subtitle = appointment!.fullReadableTime;
      imageUrl = appointment!.hike.images[0];
      trailing = const Icon(Icons.chevron_right);
    } else if (hike != null) {
      title = hike!.name;
      subtitle = "Distância: ${hike!.length.toString()}km";
      imageUrl = hike!.images[0];
      trailing = Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        width: 64,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(hike!.difficultyColor),
        ),
        child: Text(
          hike!.readableDifficulty,
          style: GoogleFonts.inter(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
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
            FadeInImage.assetNetwork(
              placeholder: "assets/loading.gif",
              image: imageUrl,
              height: double.infinity,
              width: 80,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/placeholder.png",
                  height: double.infinity,
                  width: 80,
                  fit: BoxFit.cover,
                );
              },
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
                            ),
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
