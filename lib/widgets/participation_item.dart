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
      contentPadding: EdgeInsets.zero,
      leading: const Icon(
        Icons.person,
      ),
      title: Text(
        participation.profileName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.check_circle, size: 35),
            onPressed: confirmAction,
            color:
                participation.status == "P" ? AppColors.primary : Colors.grey,
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.cancel, size: 35),
            onPressed: cancelAction,
            color: participation.status == "A" ? Colors.red : Colors.grey,
          ),
        ],
      ),
    );
  }
}
