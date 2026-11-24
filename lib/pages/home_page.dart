import 'package:flutter/material.dart';
import '../data/ranger_data.dart';
import '../models/ranger.dart';
import '../widgets/featured_banner.dart';
import '../widgets/ranger_card.dart';
import 'detail_page.dart';

enum _SortBy { highestPower, nameAsc }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _favorites = <String>{};
  String _query = '';
  bool _lovedOnly = false;
  String? _selectedElement;
  _SortBy _sortBy = _SortBy.highestPower;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _elements {
    final seen = <String>{};
    final result = <String>[];
    for (final ranger in rangerData) {
      if (seen.add(ranger.element)) result.add(ranger.element);
    }
    return result;
  }

  Ranger get _featuredRanger =>
      rangerData.reduce((a, b) => a.powerLevel >= b.powerLevel ? a : b);

  List<Ranger> get _visibleRangers {
    final query = _query.trim().toLowerCase();
    final list = rangerData.where((ranger) {
      final matchesQuery = query.isEmpty ||
          ranger.codename.toLowerCase().contains(query) ||
          ranger.name.toLowerCase().contains(query) ||
          ranger.color.toLowerCase().contains(query) ||
          ranger.title.toLowerCase().contains(query) ||
          ranger.element.toLowerCase().contains(query) ||
          ranger.power.toLowerCase().contains(query);
      final matchesElement = _selectedElement == null || ranger.element == _selectedElement;
      final matchesLoved = !_lovedOnly || _favorites.contains(ranger.id);
      return matchesQuery && matchesElement && matchesLoved;
    }).toList();

    list.sort((a, b) {
      if (_sortBy == _SortBy.nameAsc) {
        return a.codename.compareTo(b.codename);
      }
      return b.powerLevel.compareTo(a.powerLevel);
    });
    return list;
  }

  void _toggleFavorite(Ranger ranger) {
    setState(() {
      if (!_favorites.add(ranger.id)) _favorites.remove(ranger.id);
    });
  }

  Future<void> _openDetail(Ranger ranger) async {
    final index = rangerData.indexWhere((r) => r.id == ranger.id) + 1;
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
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
    final items = _visibleRangers;
    final total = rangerData.length;
    final activeCount = rangerData.where((r) => r.isActive).length;
    final standbyCount = total - activeCount;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF151D35), Color(0xFF0B1020), Color(0xFF101629)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final isWide = width >= 700;
              final columns = width >= 1250
                  ? 4
                  : width >= 850
                      ? 3
                      : width >= 560
                          ? 2
                          : 1;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _header()),
                  SliverToBoxAdapter(child: _statsRow(total, activeCount, standbyCount)),
                  SliverToBoxAdapter(
                    child: FeaturedBanner(
                      ranger: _featuredRanger,
                      isWide: isWide,
                      onDeploy: () => _openDetail(_featuredRanger),
                    ),
                  ),
                  SliverToBoxAdapter(child: _searchField()),
                  SliverToBoxAdapter(child: _filterRow()),
                  SliverToBoxAdapter(child: _resultRow(items.length)),
                  if (items.isEmpty)
                    SliverFillRemaining(hasScrollBody: false, child: _emptyState())
                  else if (columns == 1)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final ranger = items[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: RangerCard(
                                ranger: ranger,
                                isFavorite: _favorites.contains(ranger.id),
                                compact: true,
                                onTap: () => _openDetail(ranger),
                                onFavoriteTap: () => _toggleFavorite(ranger),
                              ),
                            );
                          },
                          childCount: items.length,
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(18, 4, 18, 26),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 390,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final ranger = items[index];
                            return RangerCard(
                              ranger: ranger,
                              isFavorite: _favorites.contains(ranger.id),
                              onTap: () => _openDetail(ranger),
                              onFavoriteTap: () => _toggleFavorite(ranger),
                            );
                          },
                          childCount: items.length,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5252), Color(0xFFB91C1C)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEF4444).withOpacity(.28),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.shield_moon_rounded, color: Colors.white, size: 29),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RANGER ARCHIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Browse and manage heroic operatives.',
                  style: TextStyle(color: Color(0xFF9CA8C2), fontSize: 11),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => setState(() => _lovedOnly = !_lovedOnly),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: _lovedOnly ? const Color(0xFF3A1C2B) : const Color(0xFF1B2540),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _lovedOnly ? const Color(0xFFFF5364) : const Color(0xFF303D5D),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _lovedOnly ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: const Color(0xFFFF5364),
                      size: 16,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      '${_favorites.length}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsRow(int total, int active, int standby) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Row(
        children: [
          Expanded(child: _statChip('TOTAL RANGERS', '$total', const Color(0xFFB7C2D6))),
          const SizedBox(width: 10),
          Expanded(child: _statChip('ACTIVE', '$active', const Color(0xFF35D07F))),
          const SizedBox(width: 10),
          Expanded(child: _statChip('STANDBY', '$standby', const Color(0xFFFFC24B))),
        ],
      ),
    );
  }

  Widget _statChip(String label, String value, Color dotColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFF171F35),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFF303D5D)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15),
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF8996B0),
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: .4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _query = value),
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search Ranger, color, element, or power...',
          hintStyle: const TextStyle(color: Color(0xFF77839F), fontSize: 13),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF9AA7C2)),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF9AA7C2)),
                ),
          filled: true,
          fillColor: const Color(0xFF171F35),
          contentPadding: const EdgeInsets.symmetric(vertical: 17),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF303D5D)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF303D5D)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _filterRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: SizedBox(
        height: 36,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _elementChip('All Rangers', null),
            for (final element in _elements) ...[
              const SizedBox(width: 7),
              _elementChip(element, element),
            ],
          ],
        ),
      ),
    );
  }

  Widget _elementChip(String label, String? element) {
    final selected = _selectedElement == element;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => setState(() => _selectedElement = element),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFB91C1C) : const Color(0xFF171F35),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFFEF4444) : const Color(0xFF303D5D),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFFB4BED2),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _resultRow(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Row(
        children: [
          Text(
            '$count RANGERS FOUND',
            style: const TextStyle(
              color: Color(0xFF7E8BA7),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: .8,
            ),
          ),
          const Spacer(),
          PopupMenuButton<_SortBy>(
            color: const Color(0xFF171F35),
            onSelected: (value) => setState(() => _sortBy = value),
            itemBuilder: (context) => const [
              PopupMenuItem(value: _SortBy.highestPower, child: Text('Highest Power')),
              PopupMenuItem(value: _SortBy.nameAsc, child: Text('Name A-Z')),
            ],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _sortBy == _SortBy.highestPower ? 'Highest Power' : 'Name A-Z',
                  style: const TextStyle(
                    color: Color(0xFFB4BED2),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(Icons.expand_more_rounded, color: Color(0xFFB4BED2), size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _lovedOnly ? Icons.favorite_border_rounded : Icons.search_off_rounded,
              size: 54,
              color: const Color(0xFF596783),
            ),
            const SizedBox(height: 14),
            Text(
              _lovedOnly ? 'No favorite Rangers yet' : 'No Ranger found',
              style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 7),
            Text(
              _lovedOnly
                  ? 'Tap the heart on a Ranger card to add it to your collection.'
                  : 'Try another keyword or switch the filter.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF8794AF), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
