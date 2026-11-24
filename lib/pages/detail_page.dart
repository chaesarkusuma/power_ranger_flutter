import 'package:flutter/material.dart';
import '../models/ranger.dart';
import '../utils/ranger_style.dart';
import '../widgets/info_tile.dart';

/// Width breakpoint above which the dossier switches from a stacked
/// (image on top) layout to a side-by-side (image left, info right) one.
const double _wideBreakpoint = 820;

class DetailPage extends StatefulWidget {
  final Ranger ranger;
  final int index;
  final bool isFavorite;

  const DetailPage({
    super.key,
    required this.ranger,
    required this.index,
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

  void _back() => Navigator.pop(context, _isFavorite);

  void _deploy() {
    final ranger = widget.ranger;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF171F35),
        behavior: SnackBarBehavior.floating,
        content: Text(
          '${ranger.codename} has been deployed to the sector.',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ranger = widget.ranger;
    final accent = rangerAccent(ranger);

    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1020),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: _back,
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
        title: Text(
          'OPERATIVE DOSSIER // ${ranger.idTag(widget.index)}',
          style: const TextStyle(
            color: Color(0xFF9CA8C2),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: .6,
          ),
        ),
        centerTitle: true,
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= _wideBreakpoint;
            return SingleChildScrollView(
              padding: EdgeInsets.all(isWide ? 28 : 18),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 360,
                          child: _portrait(ranger, accent, height: 470),
                        ),
                        const SizedBox(width: 30),
                        Expanded(child: _content(ranger, accent)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _portrait(ranger, accent, height: 320),
                        const SizedBox(height: 22),
                        _content(ranger, accent),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _portrait(Ranger ranger, Color accent, {required double height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF171F35),
          border: Border.all(color: accent.withOpacity(.35)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              ranger.assetPath,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => Center(
                child: Icon(Icons.shield_rounded, size: 90, color: accent),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(.55),
                  ],
                  stops: const [0, .7, 1],
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.5),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(.18)),
                  ),
                  child: Text(
                    '${statusLabel(ranger.status).toUpperCase()} • ${ranger.role.toUpperCase()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .8,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String label, Color accent, {String? trailing}) {
    return Row(
      children: [
        Container(width: 3, height: 13, color: accent),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8F9DB8),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        if (trailing != null) ...[
          const Spacer(),
          Text(
            trailing,
            style: const TextStyle(
              color: Color(0xFF596783),
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: .6,
            ),
          ),
        ],
      ],
    );
  }

  Widget _content(Ranger ranger, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${ranger.role.toUpperCase()} // GRADE ${ranger.grade}',
          style: TextStyle(
            color: accent,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          ranger.name,
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 3),
        Text(
          'Codename: ${ranger.codename}',
          style: const TextStyle(color: Color(0xFF9CA8C2), fontSize: 13),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _pill(Icons.shield_rounded, ranger.role, accent),
            _pill(Icons.star_rounded, 'Rating: ${ranger.powerLevel}.0', accent),
            _pill(Icons.tag_rounded, ranger.idTag(widget.index), accent),
          ],
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: InfoTile(
                label: 'POWER LEVEL',
                value: '${ranger.powerLevel}',
                icon: Icons.bolt_rounded,
                accent: accent,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InfoTile(
                label: 'ELEMENT',
                value: ranger.element,
                icon: Icons.auto_awesome_rounded,
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
          ],
        ),
        const SizedBox(height: 24),
        _sectionHeader('MISSION PROFILE & BACKGROUND', accent),
        const SizedBox(height: 10),
        Text(
          ranger.description,
          style: const TextStyle(color: Color(0xFFD0D7E5), fontSize: 14, height: 1.65),
        ),
        const SizedBox(height: 22),
        _sectionHeader(
          'COMBAT CAPABILITIES',
          accent,
          trailing: '${ranger.abilities.length} SYSTEMS ARMED',
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF171F35),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: const Color(0xFF303D5D)),
          ),
          child: Column(
            children: [
              for (var i = 0; i < ranger.abilities.length; i++)
                _abilityRow(
                  ranger.abilities[i],
                  accent,
                  isLast: i == ranger.abilities.length - 1,
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _deploy,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB91C1C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 17),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.bolt_rounded),
            label: const Text(
              'DEPLOY OPERATIVE TO SECTOR',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: .7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pill(IconData icon, String label, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF171F35),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF303D5D)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _abilityRow(RangerAbility ability, Color accent, {required bool isLast}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFF232C48))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withOpacity(.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(ability.icon, size: 16, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ability.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF0E1428),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF303D5D)),
            ),
            child: Text(
              ability.value,
              style: TextStyle(color: accent, fontSize: 10, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
