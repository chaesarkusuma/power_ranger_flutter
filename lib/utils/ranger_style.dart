import 'package:flutter/material.dart';
import '../models/ranger.dart';

/// Centralized Minimalist Character Database color palette for Ranger Archive.
abstract final class AppColors {
  static const Color background = Color(0xFFFAF9FC);
  static const Color card = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF6F4F9);
  static const Color surfaceHover = Color(0xFFF1EEF6);
  static const Color border = Color(0xFFE8E3ED);
  static const Color primaryText = Color(0xFF252431);
  static const Color secondaryText = Color(0xFF85818F);
  static const Color favoriteActive = Color(0xFFF45B69);
  static const Color favoriteInactive = Color(0xFF85818F);
  static const Color starOrange = Color(0xFFF5A623);
}

/// Accessible identity accent color per Ranger, tuned for light surfaces.
Color rangerAccent(Ranger ranger) {
  switch (ranger.id) {
    case 'red':
      return const Color(0xFFDC2626);
    case 'blue':
      return const Color(0xFF2563EB);
    case 'green':
      return const Color(0xFF15803D);
    case 'yellow':
      return const Color(0xFFB45309);
    case 'pink':
      return const Color(0xFFDB2777);
    case 'black':
      return const Color(0xFF27272A);
    case 'white':
      return const Color(0xFF475569);
    case 'purple':
      return const Color(0xFF7C3AED);
    case 'bronze':
      return const Color(0xFF92400E);
    case 'grey':
      return const Color(0xFF4B5563);
    case 'orange':
      return const Color(0xFFEA580C);
    case 'silver':
      return const Color(0xFF475569);
    case 'gold':
      return const Color(0xFFA16207);
    case 'navy':
      return const Color(0xFF1D4ED8);
    case 'teal':
      return const Color(0xFF0F766E);
    default:
      return const Color(0xFF4B5563);
  }
}

Color statusColor(RangerStatus status) {
  return status == RangerStatus.active
      ? const Color(0xFF16A34A)
      : AppColors.starOrange;
}

String statusLabel(RangerStatus status) {
  return status == RangerStatus.active ? 'Active' : 'Standby';
}
