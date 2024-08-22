import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/models/pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:poke_prueba/states.dart';
import 'package:poke_prueba/models/type.dart'; // Asegúrate de importar el archivo con el enumerado

class CartaPokemon extends StatelessWidget {
  final Pokemon pokemon;

  const CartaPokemon({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        final isFavorite = context.read<PokemonBloc>().favoritePokemons.contains(pokemon);
        final icon = isFavorite ? Icons.favorite : Icons.favorite_border;

        return InkWell(
          onTap: () {
            context.read<PokemonBloc>().add(SelectPokemon(selectedPokemon: pokemon, context: context));
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6,
            margin: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, right: 15),
                      child: IconButton(
                        onPressed: () {
                          context.read<PokemonBloc>().add(ToggleFavorite(pokemon: pokemon));
                        },
                        icon: Icon(icon),
                        color: Colors.red,
                        iconSize: 30,
                      ),
                    ),
                  ],
                ),
                ClipRRect(
                  child: SizedBox(
                    height: 200,
                    child: CachedNetworkImage(
                      imageUrl: pokemon.photo,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ), 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    pokemon.name,
                    style: const TextStyle(
                      fontSize: 22, // Aumenta el tamaño del texto para adaptarlo al nuevo tamaño
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
