import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/models/participation.dart';

class ParticipationItem extends StatelessWidget {
  const ParticipationItem({
    super.key,
    required this.participation,
    required this.confirmAction,
    required this.cancelAction,
  });

  final ParticipationModel participation;
  final void Function() confirmAction;
  final void Function() cancelAction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.person,
      ),
      title: Text(participation.profileName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.verified),
            onPressed: confirmAction,
            color: participation.status == "P" ? AppColors.primary : Colors.grey,
          ),
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: cancelAction,
            color: participation.status == "A" ? Colors.red : Colors.grey,
          ),
        ],
      ),
    );
  }
}
