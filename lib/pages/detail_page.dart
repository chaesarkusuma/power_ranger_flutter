import 'package:flutter/material.dart';
import 'package:power_ranger/models/pokemon.dart';

class DetailPage extends StatelessWidget {
  final Pokemon pokemon;
  const DetailPage({super.key, required this.pokemon});

  // Warna tiap elemen (pakai Map biar singkat)
  static const Map<String, Color> typeColors = {
    'Fire': Colors.red,
    'Steel': Colors.blueGrey,
    'Water': Colors.blue,
    'Earth': Colors.brown,
    'Wind': Colors.teal,
    'Shadow': Colors.deepPurple,
    'Lightning': Colors.orange,
    'Sky': Colors.lightBlue,
    'Light': Colors.amber,
    'Psychic': Colors.pink,
  };

  @override
  Widget build(BuildContext context) {
    // kalau elemen tidak ada di Map, pakai abu-abu
    final Color color = typeColors[pokemon.type] ?? Colors.grey;

    return Scaffold(
      appBar: AppBar(title: Text(pokemon.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(pokemon.image),
            ),

            const SizedBox(height: 16),

            // 2. Nama
            Text(
              pokemon.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // 3. Chip elemen + base power
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color),
                  ),
                  child: Text(
                    pokemon.type,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: Text(
                    'Power: ${pokemon.basePower}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 4. Deskripsi
            const Text(
              'Deskripsi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  pokemon.description,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 5. Skill
            const Text(
              'Skill',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Icon(Icons.star, color: color),
                title: Text('${pokemon.type} Power'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}