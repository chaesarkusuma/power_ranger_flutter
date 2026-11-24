import 'package:flutter/material.dart';
import '../models/ranger.dart';
import '../utils/ranger_style.dart';

class RangerCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final accent = rangerAccent(ranger);
    return Material(
      color: const Color(0xFF171F35),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF303D5D)),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: compact ? _compactLayout(accent) : _gridLayout(accent),
        ),
      ),
    );
  }

  Widget _image({
    required double height,
    required double width,
    required Color accent,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: const Color(0xFF101629)),
        Image.asset(
          ranger.assetPath,
          width: width,
          height: height,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          errorBuilder: (_, __, ___) {
            return Container(
              color: accent.withOpacity(.12),
              child: Icon(Icons.shield_rounded, color: accent, size: 56),
            );
          },
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(.12),
                Colors.transparent,
                const Color(0xFF101629).withOpacity(.65),
              ],
              stops: const [0, .55, 1],
            ),
          ),
        ),
        // Element badge, top-left.
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.48),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(.18)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  ranger.element.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Favorite button, top-right.
        Positioned(
          top: 9,
          right: 9,
          child: Material(
            color: const Color(0xFF101629).withOpacity(.8),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onFavoriteTap,
              child: Padding(
                padding: const EdgeInsets.all(9),
                child: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFavorite ? const Color(0xFFFF5364) : Colors.white,
                  size: 19,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomRow(Color accent) {
    return Row(
      children: [
        Icon(Icons.bolt_rounded, color: accent, size: 15),
        const SizedBox(width: 4),
        Text(
          '${ranger.powerLevel} POWER',
          style: TextStyle(
            color: accent,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: .5,
          ),
        ),
        const Spacer(),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: statusColor(ranger.status),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          statusLabel(ranger.status),
          style: TextStyle(
            color: statusColor(ranger.status),
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: .4,
          ),
        ),
      ],
    );
  }

  Widget _gridLayout(Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 245,
          width: double.infinity,
          child: _image(height: 245, width: double.infinity, accent: accent),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ranger.codename,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  ranger.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  ranger.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF8996B0), fontSize: 10),
                ),
                const Spacer(),
                _bottomRow(accent),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _compactLayout(Color accent) {
    return SizedBox(
      height: 180,
      child: Row(
        children: [
          SizedBox(
            width: 132,
            height: double.infinity,
            child: _image(height: 180, width: 132, accent: accent),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(13, 13, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ranger.codename,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ranger.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: accent, fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    '${ranger.element} • ${ranger.power}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFFB1BCD0), fontSize: 11),
                  ),
                  const Spacer(),
                  _bottomRow(accent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
