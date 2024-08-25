import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/models/pokemon.dart';
import 'package:poke_prueba/models/type.dart';
import 'package:poke_prueba/states.dart';
import 'package:poke_prueba/theme/theme.dart';

class PokemonDetailsPage extends StatelessWidget {
  final Pokemon pokemon;

  PokemonDetailsPage({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    // Ajusta el widthFactor según el tamaño de la pantalla
    double widthFactor;
    if (sizeScreen.width >= 1200) { // Ordenador
      widthFactor = AppFactorWidth.widthFactorComputer;
    } else if (sizeScreen.width >= 800) { // Tablet
      widthFactor = AppFactorWidth.widthFactorTablet;
    } else { // Móviles
      widthFactor = AppFactorWidth.widthFactorMobile;
    }

    final Color background = Type.values.firstWhere(
      (type) => type.name.toLowerCase() == pokemon.types.first.toLowerCase(),
    ).color;

    return Container(
      color: background,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: SingleChildScrollView(  // Se asegura de que la pantalla pueda desplazarse
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => context.read<PokemonBloc>().add(ClearSelection()),
                      ),
                      BlocBuilder<PokemonBloc, PokemonState>(
                        builder: (context, state) {
                          final isFavorite = context.read<PokemonBloc>().favoritePokemons.contains(pokemon);
                              
                          return IconButton(
                            icon: Icon(
                              isFavorite ? Icons.star : Icons.star_border,
                              color: isFavorite ? Colors.yellow : Colors.white,
                            ),
                            iconSize: 40,
                            onPressed: () {
                              context.read<PokemonBloc>().add(ToggleFavorite(pokemon: pokemon));
                            },
                          );
                        },
                      ),
                    ]
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            pokemon.photo,
                            height: 200,
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
                      const SizedBox(height: 20),
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
                      Wrap(
                        spacing: 8.0, // Espaciado horizontal entre las habilidades
                        runSpacing: 4.0, // Espaciado vertical si las habilidades se desbordan en varias líneas
                        children: pokemon.habilities.map((hability) {
                          return Chip(
                            label: Text(
                              hability,
                              style: const TextStyle(fontSize: 18),
                            ),
                            backgroundColor: Colors.grey[200], // Color de fondo del chip
                          );
                        }).toList(),
                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
