import 'package:flutter/material.dart';
import '../data/ranger_data.dart';
import '../models/ranger.dart';
import '../widgets/ranger_card.dart';
import 'detail_page.dart';

enum RangerFilter { all, loved, notLoved }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _favorites = <String>{};
  String _query = '';
  RangerFilter _filter = RangerFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Ranger> get _visibleRangers {
    final query = _query.trim().toLowerCase();
    return rangerData.where((ranger) {
      final matchesQuery = query.isEmpty ||
          ranger.name.toLowerCase().contains(query) ||
          ranger.color.toLowerCase().contains(query) ||
          ranger.title.toLowerCase().contains(query) ||
          ranger.element.toLowerCase().contains(query) ||
          ranger.power.toLowerCase().contains(query);
      final isLoved = _favorites.contains(ranger.id);
      final matchesFilter = switch (_filter) {
        RangerFilter.all => true,
        RangerFilter.loved => isLoved,
        RangerFilter.notLoved => !isLoved,
      };
      return matchesQuery && matchesFilter;
    }).toList();
  }

  void _toggleFavorite(Ranger ranger) {
    setState(() {
      if (!_favorites.add(ranger.id)) _favorites.remove(ranger.id);
    });
  }

  Future<void> _openDetail(Ranger ranger) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPage(
          ranger: ranger,
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
          child: Column(
            children: [
              _header(),
              _searchAndFilters(),
              Expanded(
                child: items.isEmpty
                    ? _emptyState()
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final columns = width >= 1250
                              ? 4
                              : width >= 850
                                  ? 3
                                  : width >= 560
                                      ? 2
                                      : 1;
                          if (columns == 1) {
                            return ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                              itemCount: items.length,
                              itemBuilder: (_, index) {
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
                            );
                          }
                          return GridView.builder(
                            padding: const EdgeInsets.fromLTRB(18, 4, 18, 26),
                            itemCount: items.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              mainAxisExtent: 390,
                            ),
                            itemBuilder: (_, index) {
                              final ranger = items[index];
                              return RangerCard(
                                ranger: ranger,
                                isFavorite: _favorites.contains(ranger.id),
                                onTap: () => _openDetail(ranger),
                                onFavoriteTap: () => _toggleFavorite(ranger),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
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
            child: const Icon(Icons.shield_moon_rounded,
                color: Colors.white, size: 29),
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
                  'Discover your heroes. Build your team.',
                  style: TextStyle(color: Color(0xFF9CA8C2), fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2540),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF303D5D)),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite_rounded,
                    color: Color(0xFFFF5364), size: 16),
                const SizedBox(width: 7),
                Text(
                  '${_favorites.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchAndFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 14),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search Ranger, color, element, or power...',
              hintStyle: const TextStyle(color: Color(0xFF77839F), fontSize: 13),
              prefixIcon: const Icon(Icons.search_rounded,
                  color: Color(0xFF9AA7C2)),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      icon: const Icon(Icons.close_rounded,
                          color: Color(0xFF9AA7C2)),
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
          const SizedBox(height: 13),
          Row(
            children: [
              const Text('FILTER',
                  style: TextStyle(
                    color: Color(0xFF7E8BA7),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  )),
              const SizedBox(width: 12),
              _filterChip('All Rangers', RangerFilter.all, Icons.grid_view_rounded),
              const SizedBox(width: 7),
              _filterChip('Loved', RangerFilter.loved, Icons.favorite_rounded),
              const SizedBox(width: 7),
              _filterChip('Not Loved', RangerFilter.notLoved,
                  Icons.favorite_border_rounded),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '${_visibleRangers.length} RANGERS FOUND',
                style: const TextStyle(
                  color: Color(0xFF7E8BA7),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .8,
                ),
              ),
              const Spacer(),
              if (_filter == RangerFilter.loved)
                const Text('YOUR FAVORITES',
                    style: TextStyle(
                      color: Color(0xFFFF6877),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    )),
              if (_filter == RangerFilter.notLoved)
                const Text('NOT IN YOUR COLLECTION',
                    style: TextStyle(
                      color: Color(0xFF8C99B4),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, RangerFilter filter, IconData icon) {
    final selected = _filter == filter;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _filter = filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 11),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFB91C1C) : const Color(0xFF171F35),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? const Color(0xFFEF4444) : const Color(0xFF303D5D),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 14,
                  color: selected ? Colors.white : const Color(0xFF9AA7C2)),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFFB4BED2),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    final loved = _filter == RangerFilter.loved;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              loved ? Icons.favorite_border_rounded : Icons.search_off_rounded,
              size: 54,
              color: const Color(0xFF596783),
            ),
            const SizedBox(height: 14),
            Text(
              loved ? 'No favorite Rangers yet' : 'No Ranger found',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              loved
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
