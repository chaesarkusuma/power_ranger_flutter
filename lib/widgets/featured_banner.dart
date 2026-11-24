import 'package:flutter/material.dart';
import '../models/ranger.dart';
import '../utils/ranger_style.dart';
import 'info_tile.dart';

class FeaturedBanner extends StatelessWidget {
  final Ranger ranger;
  final bool isWide;
  final VoidCallback onDeploy;

  const FeaturedBanner({
    super.key,
    required this.ranger,
    required this.isWide,
    required this.onDeploy,
  });

  @override
  Widget build(BuildContext context) {
    final accent = rangerAccent(ranger);
    final image = _imageSection(accent, height: isWide ? 380 : 220, isWide: isWide);
    final content = _contentSection(accent);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF131A2E),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF303D5D)),
        ),
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 320, child: image),
                  const SizedBox(width: 22),
                  Expanded(child: content),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  image,
                  const SizedBox(height: 16),
                  content,
                ],
              ),
      ),
    );
  }

  Widget _imageSection(Color accent, {required double height, required bool isWide}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: const Color(0xFF0E1428)),
            Image.asset(
              ranger.assetPath,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => Container(
                color: accent.withOpacity(.12),
                child: Icon(Icons.shield_rounded, color: accent, size: 64),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(.05),
                    Colors.transparent,
                    const Color(0xFF0B1020).withOpacity(.55),
                  ],
                  stops: const [0, .55, 1],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentSection(Color accent) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(
                  color: accent.withOpacity(.14),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: accent.withOpacity(.4)),
                ),
                child: Text(
                  'FEATURED OPERATIVE • ${ranger.element.toUpperCase()}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .6,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: statusColor(ranger.status),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              ranger.isActive ? 'Active Duty' : 'On Standby',
              style: TextStyle(
                color: statusColor(ranger.status),
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          ranger.codename,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '${ranger.role} • ${ranger.name}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Color(0xFF9CA8C2), fontSize: 12),
        ),
        const SizedBox(height: 12),
        Text(
          ranger.description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Color(0xFFC3CBDC), fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InfoTile(
                label: 'POWER RATING',
                value: '${ranger.powerLevel}',
                icon: Icons.bolt_rounded,
                accent: accent,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InfoTile(
                label: 'MISSIONS',
                value: '${ranger.missions}',
                icon: Icons.flag_rounded,
                accent: accent,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InfoTile(
                label: 'SPECIALTY',
                value: ranger.element,
                icon: Icons.auto_awesome_rounded,
                accent: accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: onDeploy,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFB91C1C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                label: const Text(
                  'Deploy Operative',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF171F35),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF303D5D)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite_rounded, color: Color(0xFFFF5364), size: 16),
                  const SizedBox(width: 7),
                  Text(
                    '${ranger.likes}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
