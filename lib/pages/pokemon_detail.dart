import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/models/pokemon.dart';
import 'package:poke_prueba/models/type.dart';
import 'package:poke_prueba/states.dart';

class PokemonDetailsPage extends StatelessWidget {
  final Pokemon pokemon;

  PokemonDetailsPage({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    // Obtiene el color del primer tipo del Pokémon para usarlo en el AppBar
    final Color appBarBackground = Type.values.firstWhere(
      (type) => type.name.toLowerCase() == pokemon.types.first.toLowerCase(),
    ).color;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: appBarBackground,
        title: Text(pokemon.name),
        actions: [
          BlocBuilder<PokemonBloc, PokemonState>(
            builder: (context, state) {
              final isFavorite = context.read<PokemonBloc>().favoritePokemons.contains(pokemon);

              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.yellow : Colors.white,
                ),
                onPressed: () {
                  context.read<PokemonBloc>().add(ToggleFavorite(pokemon: pokemon));
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => context.read<PokemonBloc>().add(ClearSelection()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  pokemon.photo,
                  height: 250,
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
            const SizedBox(height: 40),
            Text(
              "Tipos",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: pokemon.types.map((type) {
                final typeEnum = Type.values.firstWhere(
                  (e) => e.name.toLowerCase() == type.toLowerCase(),
                );
                return Chip(
                  label: Text(
                    type,
                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                  backgroundColor: typeEnum.color,
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            Text(
              "Habilidades",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 10),
            ...pokemon.habilities.map((hability) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                " $hability",
                style: const TextStyle(fontSize: 18),
              ),
            )),
            const SizedBox(height: 40),
            Text(
              "Número en Pokédex",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
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
