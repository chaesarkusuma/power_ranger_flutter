import 'package:flutter/material.dart';
import '../models/ranger.dart';
import '../utils/ranger_style.dart';
import 'info_tile.dart';

class FeaturedBanner extends StatefulWidget {
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
  State<FeaturedBanner> createState() => _FeaturedBannerState();
}

class _FeaturedBannerState extends State<FeaturedBanner> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Ranger ranger = widget.ranger;
    final Color accent = rangerAccent(ranger);
    final Widget image = _imageSection(
      ranger,
      accent,
      height: widget.isWide ? 360 : 220,
    );
    final Widget content = _contentSection(ranger, accent);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? const Color(0xFFD5CEE0) : AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF252431).withValues(
                  alpha: _hovered ? 0.08 : 0.04,
                ),
                blurRadius: _hovered ? 20 : 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: widget.isWide
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
      ),
    );
  }

  Widget _imageSection(
    Ranger ranger,
    Color accent, {
    required double height,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: AppColors.surfaceMuted),
            Image.asset(
              ranger.assetPath,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) {
                final String lowerPath = ranger.assetPath.toLowerCase();
                if (lowerPath != ranger.assetPath) {
                  return Image.asset(
                    lowerPath,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(Icons.shield_rounded, color: accent, size: 64),
                    ),
                  );
                }
                return Center(
                  child: Icon(Icons.shield_rounded, color: accent, size: 64),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentSection(Ranger ranger, Color accent) {
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
                  color: accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: accent.withValues(alpha: 0.35)),
                ),
                child: Text(
                  'FEATURED OPERATIVE • ${ranger.element.toUpperCase()}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
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
                fontSize: 11,
                fontWeight: FontWeight.w600,
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
            color: AppColors.primaryText,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '${ranger.role} • ${ranger.name}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.secondaryText, fontSize: 13),
        ),
        const SizedBox(height: 12),
        Text(
          ranger.description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 13.5,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InfoTile(
                label: 'POWER RATING',
                value: '${ranger.powerLevel}',
                icon: Icons.star_rounded,
                accent: AppColors.starOrange,
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
                onPressed: widget.onDeploy,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryText,
                  foregroundColor: AppColors.card,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                label: const Text(
                  'Deploy Operative',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.favorite_rounded,
                    color: AppColors.favoriteActive,
                    size: 16,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '${ranger.likes}',
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w700,
                    ),
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
