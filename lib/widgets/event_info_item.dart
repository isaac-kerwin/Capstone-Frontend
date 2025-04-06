import 'package:flutter/material.dart';

class EventInfoItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  String? subtitle;

  EventInfoItem({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded (
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              softWrap: true,
            ),
            const SizedBox(height: 4),
            if (subtitle != null) 
              Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  softWrap: true,
                ),
          ],
        ),
        ),
      ],
    );
  }
}