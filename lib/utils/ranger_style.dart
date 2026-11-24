import 'package:flutter/material.dart';
import '../models/ranger.dart';

/// The accent color associated with each Ranger, used for badges,
/// icons and highlighted text throughout the app.
Color rangerAccent(Ranger ranger) {
  switch (ranger.id) {
    case 'red':
      return const Color(0xFFFF5252);
    case 'blue':
      return const Color(0xFF429BFF);
    case 'green':
      return const Color(0xFF35D07F);
    case 'yellow':
      return const Color(0xFFFFD34D);
    case 'pink':
      return const Color(0xFFFF72C6);
    case 'black':
      return const Color(0xFFB0B8C8);
    case 'white':
      return const Color(0xFFE7EAF2);
    case 'purple':
      return const Color(0xFFB17CFF);
    case 'bronze':
      return const Color(0xFFC88A55);
    case 'grey':
      return const Color(0xFF9EACC1);
    case 'orange':
      return const Color(0xFFFF8A3D);
    case 'silver':
      return const Color(0xFFD5DCE8);
    case 'gold':
      return const Color(0xFFF4C542);
    case 'navy':
      return const Color(0xFF5C7CFA);
    case 'teal':
      return const Color(0xFF2DD4BF);
    default:
      return const Color(0xFF9EACC1);
  }
}

Color statusColor(RangerStatus status) {
  return status == RangerStatus.active
      ? const Color(0xFF35D07F)
      : const Color(0xFFFFC24B);
}

String statusLabel(RangerStatus status) {
  return status == RangerStatus.active ? 'Active' : 'Standby';
}
