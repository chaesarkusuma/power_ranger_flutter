import 'package:flutter/material.dart';
import '../data/ranger_data.dart';
import '../models/ranger.dart';
import '../utils/ranger_style.dart';
import '../widgets/ranger_card.dart';
import 'detail_page.dart';

/// Displays all Rangers saved to favorites in the minimalist grid layout.
class FavoritesPage extends StatefulWidget {
  final Set<String> initialFavorites;

  const FavoritesPage({
    super.key,
    required this.initialFavorites,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Set<String> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = Set<String>.from(widget.initialFavorites);
  }

  List<Ranger> get _favoriteRangers => rangerData
      .where((Ranger ranger) => _favorites.contains(ranger.id))
      .toList();

  void _back() => Navigator.of(context).pop(Set<String>.from(_favorites));

  void _toggleFavorite(Ranger ranger) {
    setState(() {
      if (!_favorites.add(ranger.id)) {
        _favorites.remove(ranger.id);
      }
    });
  }

  Future<void> _openDetail(Ranger ranger) async {
    final int index = rangerData.indexWhere((Ranger r) => r.id == ranger.id) + 1;
    final bool? result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => DetailPage(
          ranger: ranger,
          index: index,
          isFavorite: _favorites.contains(ranger.id),
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        if (result) {
          _favorites.add(ranger.id);
        } else {
          _favorites.remove(ranger.id);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Ranger> items = _favoriteRangers;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        Navigator.of(context).pop(Set<String>.from(_favorites));
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            _FavoritesNavbar(
              count: items.length,
              onBack: _back,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double width = constraints.maxWidth;
                  final bool isMobile = width < 600;
                  final bool isTablet = width >= 600 && width < 1024;
                  final int columns = width >= 1024
                      ? 3
                      : width >= 600
                          ? 2
                          : 1;
                  final double horizontalPad =
                      isMobile ? 16 : (isTablet ? 24 : 32);
                  final double contentWidth =
                      (width > 1280 ? 1280 : width) - (horizontalPad * 2);
                  final double spacing = columns >= 3 ? 20 : 16;
                  final double cardWidth = columns >= 2
                      ? (contentWidth - spacing * (columns - 1)) / columns
                      : contentWidth;

                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1280),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                horizontalPad,
                                isMobile ? 20 : 28,
                                horizontalPad,
                                20,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'SAVED COLLECTION',
                                          style: TextStyle(
                                            color: AppColors.secondaryText,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.1,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Favorite Rangers',
                                          style: TextStyle(
                                            color: AppColors.primaryText,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.card,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.border,
                                      ),
                                    ),
                                    child: Text(
                                      '${items.length} RANGERS',
                                      style: const TextStyle(
                                        color: AppColors.secondaryText,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (items.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppColors.card,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.border,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.favorite_border_rounded,
                                      color: AppColors.secondaryText,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No favorite Rangers yet',
                                    style: TextStyle(
                                      color: AppColors.primaryText,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Tap the heart icon on any Ranger card to save it here.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.secondaryText,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else if (columns == 1)
                        SliverToBoxAdapter(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1280),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                  horizontalPad,
                                  0,
                                  horizontalPad,
                                  28,
                                ),
                                child: Column(
                                  children: [
                                    for (final Ranger ranger in items)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: RangerCard(
                                          ranger: ranger,
                                          isFavorite: true,
                                          onTap: () => _openDetail(ranger),
                                          onFavoriteTap: () =>
                                              _toggleFavorite(ranger),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        SliverToBoxAdapter(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1280),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                  horizontalPad,
                                  0,
                                  horizontalPad,
                                  36,
                                ),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    crossAxisSpacing: spacing,
                                    mainAxisSpacing: spacing,
                                    mainAxisExtent: cardWidth + 92,
                                  ),
                                  itemCount: items.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final Ranger ranger = items[index];
                                    return RangerCard(
                                      ranger: ranger,
                                      isFavorite: true,
                                      onTap: () => _openDetail(ranger),
                                      onFavoriteTap: () =>
                                          _toggleFavorite(ranger),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesNavbar extends StatelessWidget {
  final int count;
  final VoidCallback onBack;

  const _FavoritesNavbar({
    required this.count,
    required this.onBack,
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
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        color: AppColors.surfaceMuted,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          key: const ValueKey<String>('favorites-back-button'),
                          onTap: onBack,
                          customBorder: const CircleBorder(),
                          hoverColor: AppColors.surfaceHover,
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 56),
                      child: Text(
                        'Favorites',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.favorite_rounded,
                            color: AppColors.favoriteActive,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '$count',
                            style: const TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
