import 'package:flutter/material.dart';
import 'package:poke_prueba/models/pokemon.dart';
import 'package:poke_prueba/models/type.dart';

class PokemonDetailsPage extends StatelessWidget {
  final Pokemon pokemon;

  PokemonDetailsPage({
    required this.pokemon
  });

  @override
  Widget build(BuildContext context) {
    final Color appBarBackground = Type.values.firstWhere((type) 
                               => type.name.toLowerCase() == pokemon.types.first.toLowerCase())
                               .color;
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
        backgroundColor: appBarBackground,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  pokemon.photo,
                  height: 250, // Altura fija para la imagen del Pokémon
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              pokemon.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Tipos",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              alignment: WrapAlignment.center,
              children: pokemon.types.map((type) {
                final typeEnum = Type.values.firstWhere((e) => e.name.toLowerCase() == type.toLowerCase());
                return Chip(
                  label: Text(
                    type,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: typeEnum.color,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              "Habilidades",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            ...pokemon.habilities.map((hability) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                "- $hability",
                style: const TextStyle(fontSize: 18),
              ),
            )),
            const SizedBox(height: 20),
            Text(
              "Número en Pokédex",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              pokemon.numPokedex.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
