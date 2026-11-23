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
      case 'red': return const Color(0xFFFF5252);
      case 'blue': return const Color(0xFF429BFF);
      case 'green': return const Color(0xFF35D07F);
      case 'yellow': return const Color(0xFFFFD34D);
      case 'pink': return const Color(0xFFFF72C6);
      case 'purple': return const Color(0xFFB17CFF);
      case 'bronze': return const Color(0xFFC88A55);
      default: return const Color(0xFFB7C2D6);
    }
  }

  void _back() => Navigator.pop(context, _isFavorite);

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
            leading: IconButton(
              onPressed: _back,
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: () => setState(() => _isFavorite = !_isFavorite),
                icon: Icon(
                  _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: _isFavorite ? const Color(0xFFFF5364) : Colors.white,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 4 / 4.6,
                          child: Image.asset(ranger.assetPath, fit: BoxFit.cover),
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, const Color(0xFF0B1020).withOpacity(.92)],
                                stops: const [.48, 1],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 18,
                          right: 18,
                          bottom: 18,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ranger.color.toUpperCase(),
                                  style: TextStyle(color: _accent, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2)),
                              const SizedBox(height: 5),
                              Text(ranger.name,
                                  style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                              Text(ranger.title,
                                  style: const TextStyle(color: Color(0xFFB9C4D8), fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _stat('POWER LEVEL', '${ranger.powerLevel}', Icons.bolt_rounded),
                          const SizedBox(width: 10),
                          _stat('ELEMENT', ranger.element, Icons.auto_awesome_rounded),
                        ],
                      ),
                      const SizedBox(height: 22),
                      const Text('ABOUT THE RANGER',
                          style: TextStyle(color: Color(0xFF8F9DB8), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                      const SizedBox(height: 9),
                      Text(ranger.description,
                          style: const TextStyle(color: Color(0xFFD0D7E5), fontSize: 14, height: 1.65)),
                      const SizedBox(height: 22),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF171F35),
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: const Color(0xFF303D5D)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.flash_on_rounded, color: _accent, size: 23),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('SIGNATURE POWER',
                                      style: TextStyle(color: Color(0xFF8996B0), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
                                  const SizedBox(height: 4),
                                  Text(ranger.power,
                                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => setState(() => _isFavorite = !_isFavorite),
                          style: FilledButton.styleFrom(
                            backgroundColor: _isFavorite ? const Color(0xFF29344D) : const Color(0xFFB91C1C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: Icon(_isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded),
                          label: Text(_isFavorite ? 'REMOVE FROM FAVORITES' : 'ADD TO FAVORITES',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: .7)),
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF171F35),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF303D5D)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: _accent, size: 18),
            const SizedBox(height: 9),
            Text(label, style: const TextStyle(color: Color(0xFF8996B0), fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: .8)),
            const SizedBox(height: 4),
            Text(value, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}
