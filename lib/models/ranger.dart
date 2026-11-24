import 'package:flutter/material.dart';

/// Current deployment status of a Ranger.
enum RangerStatus { active, standby }

/// One row shown inside the "Combat Capabilities" list on the dossier page.
class RangerAbility {
  final String name;
  final String value;
  final IconData icon;

  const RangerAbility({
    required this.name,
    required this.value,
    required this.icon,
  });
}

class Ranger {
  final String id;

  /// The operative's real name, e.g. "Dimas Pratama".
  final String name;

  /// The hero codename, e.g. "Red Ranger".
  final String codename;

  /// Indonesian color name, e.g. "Merah".
  final String color;

  /// Short flavor title, e.g. "The Flame Leader".
  final String title;

  /// Squad role, e.g. "Leader • Assault".
  final String role;

  final String element;
  final String power;
  final String description;
  final String assetPath;
  final int powerLevel;
  final int missions;
  final int likes;
  final RangerStatus status;

  const Ranger({
    required this.id,
    required this.name,
    required this.codename,
    required this.color,
    required this.title,
    required this.role,
    required this.element,
    required this.power,
    required this.description,
    required this.assetPath,
    required this.powerLevel,
    required this.missions,
    required this.likes,
    required this.status,
  });

  bool get isActive => status == RangerStatus.active;

  /// Letter grade derived from the power rating, shown on the dossier.
  String get grade {
    if (powerLevel >= 97) return 'S';
    if (powerLevel >= 93) return 'A';
    if (powerLevel >= 88) return 'B';
    return 'C';
  }

  /// A short operative id tag, e.g. "RED-07".
  String idTag(int index) {
    final prefix = id.length >= 3 ? id.substring(0, 3) : id;
    return '${prefix.toUpperCase()}-${index.toString().padLeft(2, '0')}';
  }

  /// The 4 combat-capability rows shown on the dossier page, generated
  /// from this Ranger's own stats so every operative gets a unique,
  /// consistent readout without needing extra hand-authored data.
  List<RangerAbility> get abilities => [
        RangerAbility(
          name: '$power Overdrive',
          value: powerLevel >= 95 ? 'LV. MAX' : 'LV. ${(powerLevel / 20).ceil()}',
          icon: Icons.offline_bolt_rounded,
        ),
        RangerAbility(
          name: '$element Mastery',
          value: '$powerLevel% MASTERY',
          icon: Icons.auto_awesome_rounded,
        ),
        RangerAbility(
          name: 'Elemental Aegis Shield',
          value: 'DEF ${powerLevel * 45}',
          icon: Icons.shield_rounded,
        ),
        const RangerAbility(
          name: 'Tactical Command Matrix',
          value: 'ACTIVE AURA',
          icon: Icons.hub_rounded,
        ),
      ];
}
