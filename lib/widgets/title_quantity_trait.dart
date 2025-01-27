import 'package:flutter/material.dart';

class TitleQuantityTrait extends StatelessWidget {
  const TitleQuantityTrait({
    super.key,
    required this.number,
    required this.title,
    required this.color,
  });

  final int number;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Container(
            width: 35,
            height: 35,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              number.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 5,),
          Text(title),
        ],
      ),
    );
  }
}
