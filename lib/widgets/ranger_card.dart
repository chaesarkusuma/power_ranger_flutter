import 'package:flutter/material.dart';
import '../models/ranger.dart';
import '../utils/ranger_style.dart';

/// Minimalist character card inspired by the clean database reference layout:
/// large portrait focus with top-right heart button, name, color badge, and rating.
class RangerCard extends StatefulWidget {
  final Ranger ranger;
  final bool isFavorite;
  final bool compact;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const RangerCard({
    super.key,
    required this.ranger,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
    this.compact = false,
  });

  @override
  State<RangerCard> createState() => _RangerCardState();
}

class _RangerCardState extends State<RangerCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Ranger ranger = widget.ranger;
    final Color accent = rangerAccent(ranger);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF252431).withValues(
                alpha: _hovered ? 0.09 : 0.04,
              ),
              blurRadius: _hovered ? 22 : 14,
              offset: Offset(0, _hovered ? 8 : 4),
            ),
          ],
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? const Color(0xFFD5CEE0)
                : AppColors.border,
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            hoverColor: Colors.transparent,
            splashColor: accent.withValues(alpha: 0.06),
            highlightColor: accent.withValues(alpha: 0.03),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: _PortraitSection(
                    ranger: ranger,
                    accent: accent,
                    isFavorite: widget.isFavorite,
                    onFavoriteTap: widget.onFavoriteTap,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ranger.codename,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accent.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: accent.withValues(alpha: 0.35),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    ranger.color,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: accent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    ranger.role,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.secondaryText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.starOrange,
                                size: 17,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${ranger.powerLevel}',
                                style: const TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PortraitSection extends StatelessWidget {
  final Ranger ranger;
  final Color accent;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const _PortraitSection({
    required this.ranger,
    required this.accent,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  Widget _placeholder() {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: Center(
        child: Icon(Icons.shield_rounded, color: accent, size: 56),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                errorBuilder: (_, __, ___) => _placeholder(),
              );
            }
            return _placeholder();
          },
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Material(
            color: AppColors.card.withValues(alpha: 0.94),
            shape: const CircleBorder(
              side: BorderSide(color: AppColors.border, width: 1),
            ),
            elevation: 1,
            shadowColor: const Color(0x14252431),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              customBorder: const CircleBorder(),
              hoverColor: AppColors.surfaceMuted,
              onTap: onFavoriteTap,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  child: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    key: ValueKey<bool>(isFavorite),
                    color: isFavorite
                        ? AppColors.favoriteActive
                        : AppColors.favoriteInactive,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
