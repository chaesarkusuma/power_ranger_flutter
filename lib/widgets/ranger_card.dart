
import 'package:flutter/material.dart';
import '../models/ranger.dart';

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

  Color get _accent {
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
      default:
        return const Color(0xFF9EACC1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF171F35),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF303D5D),
            ),
            boxShadow: [
              BoxShadow(
                color: _accent.withOpacity(.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: compact ? _compactLayout() : _gridLayout(),
        ),
      ),
    );
  }

  Widget _image({
    required double height,
    required double width,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: const Color(0xFF171F35),
        ),

        // Ranger image
        Image.asset(
          ranger.assetPath,
          width: width,
          height: height,
          fit: BoxFit.contain,
          alignment: Alignment.center,
          errorBuilder: (_, __, ___) {
            return Container(
              color: _accent.withOpacity(.12),
              child: Icon(
                Icons.shield_rounded,
                color: _accent,
                size: 56,
              ),
            );
          },
        ),

        // Image gradient overlay
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

        // Ranger color badge
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.48),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(.18),
              ),
            ),
            child: Text(
              ranger.color.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        ),

        // Favorite button
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
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFavorite
                      ? const Color(0xFFFF5364)
                      : Colors.white,
                  size: 19,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _gridLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 245,
          width: double.infinity,
          child: _image(
            height: 245,
            width: double.infinity,
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ranger.name,
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
                  style: TextStyle(
                    color: _accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const Spacer(),

                Row(
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      color: _accent,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${ranger.powerLevel} POWER',
                      style: TextStyle(
                        color: _accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .7,
                      ),
                    ),

                    const Spacer(),

                    const Text(
                      'VIEW PROFILE',
                      style: TextStyle(
                        color: Color(0xFF9AA7C2),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .6,
                      ),
                    ),

                    const SizedBox(width: 4),

                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFF9AA7C2),
                      size: 13,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _compactLayout() {
    return SizedBox(
      height: 180,
      child: Row(
        children: [
          SizedBox(
            width: 132,
            height: double.infinity,
            child: _image(
              height: 180,
              width: 132,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(13, 13, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ranger.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    ranger.title,
                    style: TextStyle(
                      color: _accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 9),

                  Text(
                    '${ranger.element} • ${ranger.power}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFB1BCD0),
                      fontSize: 11,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Icon(
                        Icons.bolt_rounded,
                        color: _accent,
                        size: 15,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        '${ranger.powerLevel} POWER',
                        style: TextStyle(
                          color: _accent,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const Spacer(),

                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Color(0xFF9AA7C2),
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
