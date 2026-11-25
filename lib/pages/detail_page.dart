import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../models/ranger.dart';
import '../utils/ranger_style.dart';

/// Responsive detail page showcasing a Power Ranger operative inside a clean,
/// minimalist light character database card layout.
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

  @override
  void didUpdateWidget(covariant DetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite ||
        oldWidget.ranger.id != widget.ranger.id) {
      _isFavorite = widget.isFavorite;
    }
  }

  void _back() => Navigator.of(context).pop(_isFavorite);

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
  }

  void _deploy() {
    final Ranger ranger = widget.ranger;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryText,
        behavior: SnackBarBehavior.floating,
        content: Text(
          '${ranger.codename} has been deployed to the sector.',
          style: const TextStyle(color: AppColors.card),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Ranger ranger = widget.ranger;
    final Color accentColor = rangerAccent(ranger);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        Navigator.of(context).pop(_isFavorite);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints pageConstraints) {
            final double pageWidth = pageConstraints.maxWidth;
            final bool isMobile = pageWidth < 600;
            final bool isTablet = pageWidth >= 600 && pageWidth < 960;
            final double horizontalPadding =
                isMobile ? 16 : (isTablet ? 24 : 32);
            final double verticalPadding =
                isMobile ? 16 : (isTablet ? 24 : 32);

            return Column(
              children: [
                _DetailNavbar(
                  title: ranger.codename,
                  isFavorite: _isFavorite,
                  isMobile: isMobile,
                  onBack: _back,
                  onToggleFavorite: _toggleFavorite,
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints viewport) {
                      final double minCenterHeight = math.max(
                        0,
                        viewport.maxHeight - (verticalPadding * 2),
                      );

                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalPadding,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: minCenterHeight,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 1300,
                              ),
                              child: _MainDetailCard(
                                ranger: ranger,
                                index: widget.index,
                                accentColor: accentColor,
                                isMobile: isMobile,
                                isTablet: isTablet,
                                onDeploy: _deploy,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DetailNavbar extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final bool isMobile;
  final VoidCallback onBack;
  final VoidCallback onToggleFavorite;

  const _DetailNavbar({
    required this.title,
    required this.isFavorite,
    required this.isMobile,
    required this.onBack,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: _CircularBackButton(onPressed: onBack),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 56),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: _FavoriteIconButton(
                    isFavorite: isFavorite,
                    onPressed: onToggleFavorite,
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

class _CircularBackButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _CircularBackButton({required this.onPressed});

  @override
  State<_CircularBackButton> createState() => _CircularBackButtonState();
}

class _CircularBackButtonState extends State<_CircularBackButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Kembali',
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surfaceHover : AppColors.surfaceMuted,
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: const ValueKey<String>('detail-back-button'),
              onTap: widget.onPressed,
              customBorder: const CircleBorder(),
              hoverColor: Colors.transparent,
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.chevron_left_rounded,
                  size: 24,
                  color: AppColors.primaryText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoriteIconButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const _FavoriteIconButton({
    required this.isFavorite,
    required this.onPressed,
  });

  @override
  State<_FavoriteIconButton> createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends State<_FavoriteIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          widget.isFavorite ? 'Hapus dari favorit' : 'Tambahkan ke favorit',
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surfaceMuted : Colors.transparent,
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: const ValueKey<String>('detail-favorite-button'),
              onTap: widget.onPressed,
              customBorder: const CircleBorder(),
              hoverColor: Colors.transparent,
              child: SizedBox(
                width: 40,
                height: 40,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    widget.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    key: ValueKey<bool>(widget.isFavorite),
                    size: 23,
                    color: widget.isFavorite
                        ? AppColors.favoriteActive
                        : AppColors.favoriteInactive,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MainDetailCard extends StatelessWidget {
  final Ranger ranger;
  final int index;
  final Color accentColor;
  final bool isMobile;
  final bool isTablet;
  final VoidCallback onDeploy;

  const _MainDetailCard({
    required this.ranger,
    required this.index,
    required this.accentColor,
    required this.isMobile,
    required this.isTablet,
    required this.onDeploy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D252431),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Color(0x05252431),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: isMobile
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _MobileRangerImage(
                  ranger: ranger,
                  accentColor: accentColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: _RangerInfoSection(
                    ranger: ranger,
                    index: index,
                    accentColor: accentColor,
                    isMobile: true,
                    onDeploy: onDeploy,
                  ),
                ),
              ],
            )
          : IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 4,
                    child: _DesktopRangerImage(
                      ranger: ranger,
                      accentColor: accentColor,
                      minHeight: isTablet ? 440 : 480,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: EdgeInsets.all(isTablet ? 22 : 28),
                      child: _RangerInfoSection(
                        ranger: ranger,
                        index: index,
                        accentColor: accentColor,
                        isMobile: false,
                        onDeploy: onDeploy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _DesktopRangerImage extends StatelessWidget {
  final Ranger ranger;
  final Color accentColor;
  final double minHeight;

  const _DesktopRangerImage({
    required this.ranger,
    required this.accentColor,
    required this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: ColoredBox(
        color: AppColors.surfaceMuted,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const SizedBox.shrink(),
            Positioned.fill(
              child: _RangerAssetImage(
                assetPath: ranger.assetPath,
                accentColor: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileRangerImage extends StatelessWidget {
  final Ranger ranger;
  final Color accentColor;

  const _MobileRangerImage({
    required this.ranger,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 360),
      child: ColoredBox(
        color: AppColors.surfaceMuted,
        child: AspectRatio(
          aspectRatio: 1,
          child: _RangerAssetImage(
            assetPath: ranger.assetPath,
            accentColor: accentColor,
          ),
        ),
      ),
    );
  }
}

class _RangerAssetImage extends StatelessWidget {
  final String assetPath;
  final Color accentColor;

  const _RangerAssetImage({
    required this.assetPath,
    required this.accentColor,
  });

  Widget _placeholder() {
    return Center(
      child: Icon(
        Icons.shield_rounded,
        size: 72,
        color: accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      errorBuilder: (
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) {
        final String lowerPath = assetPath.toLowerCase();
        if (lowerPath != assetPath) {
          return Image.asset(
            lowerPath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (_, __, ___) => _placeholder(),
          );
        }
        return _placeholder();
      },
    );
  }
}

class _RangerInfoSection extends StatelessWidget {
  final Ranger ranger;
  final int index;
  final Color accentColor;
  final bool isMobile;
  final VoidCallback onDeploy;

  const _RangerInfoSection({
    required this.ranger,
    required this.index,
    required this.accentColor,
    required this.isMobile,
    required this.onDeploy,
  });

  List<_InfoEntry> _additionalEntries() {
    final List<({String label, String value})> items = [
      (label: 'Real Name', value: ranger.name),
      (label: 'Ranger Color', value: ranger.color),
      (label: 'Special Power', value: ranger.power),
      (label: 'Element', value: ranger.element),
      (label: 'Role', value: ranger.role),
      (label: 'Title', value: ranger.title),
      (label: 'Missions', value: '${ranger.missions}'),
      (
        label: 'Status',
        value: '${statusLabel(ranger.status)} • ${ranger.idTag(index)}',
      ),
    ];

    return [
      for (final item in items)
        if (item.value.trim().isNotEmpty)
          _InfoEntry(label: item.label, value: item.value.trim()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<_InfoEntry> infoEntries = _additionalEntries();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ranger.codename,
          style: TextStyle(
            fontSize: isMobile ? 25 : 28,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _AccentBadge(
              label: '${ranger.color} Ranger',
              accentColor: accentColor,
            ),
            _NeutralBadge(label: ranger.role),
            _RatingBadge(powerLevel: ranger.powerLevel),
          ],
        ),
        const SizedBox(height: 18),
        const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.border,
        ),
        const SizedBox(height: 16),
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          ranger.description,
          style: const TextStyle(
            fontSize: 14,
            height: 1.55,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Abilities',
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        _AbilitiesListCard(abilities: ranger.abilities),
        if (infoEntries.isNotEmpty) ...[
          const SizedBox(height: 18),
          const Text(
            'Additional Information',
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          _AdditionalInfoCard(entries: infoEntries, isMobile: isMobile),
        ],
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            key: const ValueKey<String>('detail-deploy-button'),
            onPressed: onDeploy,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return const Color(0xFF353445);
                  }
                  return AppColors.primaryText;
                },
              ),
              foregroundColor: const WidgetStatePropertyAll<Color>(
                AppColors.card,
              ),
              padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
              shape: WidgetStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              elevation: const WidgetStatePropertyAll<double>(0),
            ),
            icon: const Icon(Icons.bolt_rounded, size: 18),
            label: const Text(
              'Deploy Operative to Sector',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AccentBadge extends StatelessWidget {
  final String label;
  final Color accentColor;

  const _AccentBadge({
    required this.label,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: accentColor,
          height: 1.2,
        ),
      ),
    );
  }
}

class _NeutralBadge extends StatelessWidget {
  final String label;

  const _NeutralBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.secondaryText,
          height: 1.2,
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final int powerLevel;

  const _RatingBadge({required this.powerLevel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            size: 16,
            color: AppColors.starOrange,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              'Base Rating: $powerLevel',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AbilitiesListCard extends StatelessWidget {
  final List<RangerAbility> abilities;

  const _AbilitiesListCard({required this.abilities});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < abilities.length; i++) ...[
            if (i > 0)
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.border,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 19,
                    color: AppColors.starOrange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      abilities[i].name,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      abilities[i].value,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoEntry {
  final String label;
  final String value;

  const _InfoEntry({required this.label, required this.value});
}

class _AdditionalInfoCard extends StatelessWidget {
  final List<_InfoEntry> entries;
  final bool isMobile;

  const _AdditionalInfoCard({
    required this.entries,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: isMobile ? _buildMobileRows() : _buildTwoColumnGrid(),
    );
  }

  Widget _buildMobileRows() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < entries.length; i++) ...[
          if (i > 0)
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.border,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    entries[i].label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entries[i].value,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTwoColumnGrid() {
    final int rowCount = (entries.length / 2).ceil();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int row = 0; row < rowCount; row++) ...[
          if (row > 0)
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.border,
            ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _cell(entries[row * 2])),
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: AppColors.border,
                ),
                Expanded(
                  child: (row * 2 + 1) < entries.length
                      ? _cell(entries[row * 2 + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _cell(_InfoEntry entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            entry.label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            entry.value,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
