
import 'package:flutter/material.dart';
import '../models/ranger.dart';

class DetailPage extends StatefulWidget {
    final Ranger ranger;
    final bool isFavorite;

  const DetailPage({
        super.key,
                required this.ranger,
                required this.isFavorite,
    });

    @override
    State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
    late bool _isFavorite;

    @override
    void initState() {
        super.initState();
        _isFavorite = widget.isFavorite;
    }

    Color get _accent {
        switch (widget.ranger.id) {
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
            case 'purple':
                return const Color(0xFFB17CFF);
            case 'bronze':
                return const Color(0xFFC88A55);
            default:
                return const Color(0xFFB7C2D6);
        }
    }

    void _back() {
        Navigator.pop(context, _isFavorite);
    }

    @override
    Widget build(BuildContext context) {
        final ranger = widget.ranger;

        return Scaffold(
                backgroundColor: const Color(0xFF0B1020),
                body: CustomScrollView(
                slivers: [
        SliverAppBar(
                pinned: true,
                backgroundColor: const Color(0xFF0B1020),
                elevation: 0,
                leading: IconButton(
                onPressed: _back,
                icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
            ),
        actions: [
        IconButton(
                onPressed: () {
            setState(() {
                _isFavorite = !_isFavorite;
            });
        },
        icon: Icon(
                _isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                color: _isFavorite
                ? const Color(0xFFFF5364)
                      : Colors.white,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),

        SliverToBoxAdapter(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
        // RANGER IMAGE
        Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
                child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                color: const Color(0xFF171F35),
                border: Border.all(
                color: _accent.withOpacity(0.35),
                        ),
        borderRadius: BorderRadius.circular(24),
                      ),
        child: AspectRatio(
                aspectRatio: 4 / 4.6,
                child: Stack(
                children: [
        Positioned.fill(
                child: Image.asset(
                ranger.assetPath,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                errorBuilder: (
                context,
                error,
                stackTrace,
                                ) {
            return Center(
                    child: Icon(
                    Icons.shield_rounded,
                    size: 90,
                    color: _accent,
                                    ),
                                  );
        },
                              ),
                            ),

        Positioned.fill(
                child: DecoratedBox(
                decoration: BoxDecoration(
                gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
        Colors.transparent,
                Colors.transparent,
                                      const Color(0xFF0B1020)
                .withOpacity(0.95),
                                    ],
        stops: const [0, 0.55, 1],
                                  ),
                                ),
                              ),
                            ),

        Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                crossAxisAlignment:
        CrossAxisAlignment.start,
                children: [
        Text(
                ranger.color.toUpperCase(),
                style: TextStyle(
                color: _accent,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
        Text(
                ranger.name,
                style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
        Text(
                ranger.title,
                style: const TextStyle(
                color: Color(0xFFB9C4D8),
                fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

        // CONTENT
        Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
        // STATS
        Row(
                children: [
        _stat(
                'POWER LEVEL',
                '${ranger.powerLevel}',
                Icons.bolt_rounded,
                ),
                          const SizedBox(width: 12),
        _stat(
                'ELEMENT',
                ranger.element,
                Icons.auto_awesome_rounded,
                ),
                        ],
                      ),

                      const SizedBox(height: 28),

        // ABOUT
                      const Text(
                'ABOUT THE RANGER',
                style: TextStyle(
                color: Color(0xFF8F9DB8),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 12),

        Text(
                ranger.description,
                style: const TextStyle(
                color: Color(0xFFD0D7E5),
                fontSize: 14,
                height: 1.7,
                        ),
                      ),

                      const SizedBox(height: 25),

        // SIGNATURE POWER
        Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                color: const Color(0xFF171F35),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                color: const Color(0xFF303D5D),
                          ),
                        ),
        child: Row(
                children: [
        Icon(
                Icons.flash_on_rounded,
                color: _accent,
                size: 27,
                            ),
                            const SizedBox(width: 14),
        Expanded(
                child: Column(
                crossAxisAlignment:
        CrossAxisAlignment.start,
                children: [
                                  const Text(
                'SIGNATURE POWER',
                style: TextStyle(
                color: Color(0xFF8996B0),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
        Text(
                ranger.power,
                style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

        // FAVORITE BUTTON
        SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                onPressed: () {
            setState(() {
                _isFavorite = !_isFavorite;
            });
        },
        style: FilledButton.styleFrom(
                backgroundColor: _isFavorite
                ? const Color(0xFF29344D)
                                : const Color(0xFFB91C1C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                vertical: 17,
                            ),
        shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                            ),
                          ),
        icon: Icon(
                _isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                ),
                label: Text(
                _isFavorite
                        ? 'REMOVE FROM FAVORITES'
                        : 'ADD TO FAVORITES',
                style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 11,
                letterSpacing: 0.7,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    }

    Widget _stat(String label, String value, IconData icon) {
        return Expanded(
                child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                color: const Color(0xFF171F35),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                color: const Color(0xFF303D5D),
          ),
        ),
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
        Icon(
                icon,
                color: _accent,
                size: 20,
            ),
            const SizedBox(height: 10),
        Text(
                label,
                style: const TextStyle(
                color: Color(0xFF8996B0),
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 5),
        Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
    }
}
