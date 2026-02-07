import 'package:flutter/material.dart';

class CustomMusicActionWidget extends StatelessWidget {
  const CustomMusicActionWidget({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          Icon(icon, color: Colors.white),
          SizedBox(height: 20),
          Text(label, style: TextStyle(color: Colors.white)),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
