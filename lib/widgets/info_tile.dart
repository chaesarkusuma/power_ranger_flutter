import 'package:flutter/material.dart';

/// A small rounded stat box: an icon, a label and a value.
/// Used on the home banner and the operative dossier page.
class InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  const InfoTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF171F35),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF303D5D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accent, size: 18),
          const SizedBox(height: 9),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8996B0),
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
