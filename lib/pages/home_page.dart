import 'package:flutter/material.dart';
import '../data/ranger_data.dart';
import '../models/ranger.dart';
import '../utils/ranger_style.dart';
import '../widgets/ranger_card.dart';
import 'detail_page.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _favorites = <String>{};
  String _query = '';
  String? _selectedColor;
  String? _selectedElement;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _colors {
    final Set<String> seen = <String>{};
    final List<String> result = <String>[];
    for (final Ranger ranger in rangerData) {
      if (seen.add(ranger.color)) result.add(ranger.color);
    }
    return result;
  }

  List<String> get _elements {
    final Set<String> seen = <String>{};
    final List<String> result = <String>[];
    for (final Ranger ranger in rangerData) {
      if (seen.add(ranger.element)) result.add(ranger.element);
    }
    return result;
  }

  List<Ranger> get _visibleRangers {
    final String query = _query.trim().toLowerCase();
    return rangerData.where((Ranger ranger) {
      final bool matchesQuery = query.isEmpty ||
          ranger.codename.toLowerCase().contains(query) ||
          ranger.name.toLowerCase().contains(query) ||
          ranger.color.toLowerCase().contains(query) ||
          ranger.role.toLowerCase().contains(query) ||
          ranger.element.toLowerCase().contains(query) ||
          ranger.power.toLowerCase().contains(query);
      final bool matchesColor =
          _selectedColor == null || ranger.color == _selectedColor;
      final bool matchesElement =
          _selectedElement == null || ranger.element == _selectedElement;
      return matchesQuery && matchesColor && matchesElement;
    }).toList();
  }

  bool get _hasActiveFilters =>
      _query.trim().isNotEmpty ||
      _selectedColor != null ||
      _selectedElement != null;

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _selectedColor = null;
      _selectedElement = null;
    });
  }

  void _toggleFavorite(Ranger ranger) {
    setState(() {
      if (!_favorites.add(ranger.id)) {
        _favorites.remove(ranger.id);
      }
    });
  }

  Future<void> _openFavorites() async {
    final Set<String>? updated = await Navigator.push<Set<String>>(
      context,
      MaterialPageRoute<Set<String>>(
        builder: (_) => FavoritesPage(initialFavorites: _favorites),
      ),
    );
    if (updated != null && mounted) {
      setState(() {
        _favorites
          ..clear()
          ..addAll(updated);
      });
    }
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
    final List<Ranger> items = _visibleRangers;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _HomeNavbar(
            favoriteCount: _favorites.length,
            onFavoritesTap: _openFavorites,
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
                              16,
                            ),
                            child: _SectionHeader(
                              rangerCount: items.length,
                              isMobile: isMobile,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1280),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              horizontalPad,
                              0,
                              horizontalPad,
                              20,
                            ),
                            child: _SearchAndFilterBar(
                              controller: _searchController,
                              query: _query,
                              colors: _colors,
                              elements: _elements,
                              selectedColor: _selectedColor,
                              selectedElement: _selectedElement,
                              hasActiveFilters: _hasActiveFilters,
                              isMobile: isMobile,
                              onQueryChanged: (String value) {
                                setState(() => _query = value);
                              },
                              onColorChanged: (String? value) {
                                setState(() => _selectedColor = value);
                              },
                              onElementChanged: (String? value) {
                                setState(() => _selectedElement = value);
                              },
                              onClear: _clearFilters,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (items.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptySearchState(onReset: _clearFilters),
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
                                        isFavorite:
                                            _favorites.contains(ranger.id),
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
                                itemBuilder: (BuildContext context, int index) {
                                  final Ranger ranger = items[index];
                                  return RangerCard(
                                    ranger: ranger,
                                    isFavorite: _favorites.contains(ranger.id),
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
    );
  }
}

class _HomeNavbar extends StatelessWidget {
  final int favoriteCount;
  final VoidCallback onFavoritesTap;

  const _HomeNavbar({
    required this.favoriteCount,
    required this.onFavoritesTap,
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
          height: 62,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    const Text(
                      'Power Rangers',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Spacer(),
                    Tooltip(
                      message: 'Favorites ($favoriteCount)',
                      child: Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          key: const ValueKey<String>('home-favorites-button'),
                          onTap: onFavoritesTap,
                          customBorder: const CircleBorder(),
                          hoverColor: AppColors.surfaceMuted,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  favoriteCount > 0
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: favoriteCount > 0
                                      ? AppColors.favoriteActive
                                      : AppColors.favoriteInactive,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
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

class _SectionHeader extends StatelessWidget {
  final int rangerCount;
  final bool isMobile;

  const _SectionHeader({
    required this.rangerCount,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'RANGER DATABASE',
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Explore the Rangers',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: isMobile ? 22 : 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            '$rangerCount RANGERS',
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchAndFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final List<String> colors;
  final List<String> elements;
  final String? selectedColor;
  final String? selectedElement;
  final bool hasActiveFilters;
  final bool isMobile;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String?> onColorChanged;
  final ValueChanged<String?> onElementChanged;
  final VoidCallback onClear;

  const _SearchAndFilterBar({
    required this.controller,
    required this.query,
    required this.colors,
    required this.elements,
    required this.selectedColor,
    required this.selectedElement,
    required this.hasActiveFilters,
    required this.isMobile,
    required this.onQueryChanged,
    required this.onColorChanged,
    required this.onElementChanged,
    required this.onClear,
  });

  Widget _searchInput() {
    return SizedBox(
      height: 42,
      child: TextField(
        controller: controller,
        onChanged: onQueryChanged,
        style: const TextStyle(color: AppColors.primaryText, fontSize: 13.5),
        cursorColor: AppColors.primaryText,
        decoration: InputDecoration(
          hintText: 'Search Ranger by name...',
          hintStyle: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 13.5,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.secondaryText,
            size: 19,
          ),
          suffixIcon: query.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    controller.clear();
                    onQueryChanged('');
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.secondaryText,
                    size: 18,
                  ),
                ),
          filled: true,
          fillColor: AppColors.card,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primaryText),
          ),
        ),
      ),
    );
  }

  Widget _filterDropdown({
    required String label,
    required String? currentValue,
    required List<String> options,
    required ValueChanged<String?> onSelected,
  }) {
    final bool active = currentValue != null;
    return PopupMenuButton<String>(
      key: ValueKey<String>('filter-$label'),
      tooltip: 'Filter by $label',
      onSelected: (String value) {
        onSelected(value == '__ALL__' ? null : value);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: '__ALL__',
          child: Text(
            'All ${label}s',
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        for (final String option in options)
          PopupMenuItem<String>(
            value: option,
            child: Text(
              option,
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 13,
                fontWeight:
                    option == currentValue ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
      ],
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.surfaceMuted : AppColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? AppColors.primaryText : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentValue == null ? '$label: All' : '$label: $currentValue',
              style: TextStyle(
                color: active ? AppColors.primaryText : AppColors.secondaryText,
                fontSize: 13,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: active ? AppColors.primaryText : AppColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _resetButton() {
    return SizedBox(
      height: 42,
      child: TextButton(
        onPressed: onClear,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.secondaryText,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Reset',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _searchInput(),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _filterDropdown(
                label: 'Color',
                currentValue: selectedColor,
                options: colors,
                onSelected: onColorChanged,
              ),
              _filterDropdown(
                label: 'Element',
                currentValue: selectedElement,
                options: elements,
                onSelected: onElementChanged,
              ),
              if (hasActiveFilters) _resetButton(),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: _searchInput()),
        const SizedBox(width: 10),
        _filterDropdown(
          label: 'Color',
          currentValue: selectedColor,
          options: colors,
          onSelected: onColorChanged,
        ),
        const SizedBox(width: 10),
        _filterDropdown(
          label: 'Element',
          currentValue: selectedElement,
          options: elements,
          onSelected: onElementChanged,
        ),
        if (hasActiveFilters) ...[
          const SizedBox(width: 6),
          _resetButton(),
        ],
      ],
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  final VoidCallback onReset;

  const _EmptySearchState({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Center(
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
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 26,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No Rangers match your filter',
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try another name or clear your active filters.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onReset,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryText,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
