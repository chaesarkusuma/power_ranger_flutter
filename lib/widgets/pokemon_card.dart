import 'package:flutter/material.dart';
import 'package:power_ranger/models/pokemon.dart';
import 'package:power_ranger/pages/detail_page.dart';
import 'package:power_ranger/widgets/type_chip.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {

    void _detailPage(Pokemon pokemon){
      Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(pokemon: pokemon)));
    }

    return InkWell(
      onTap: () {
        _detailPage(pokemon);
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        clipBehavior: Clip.antiAlias,
        child: Hero(
          tag: pokemon.name,
          child: Image.asset(
            pokemon.image,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}