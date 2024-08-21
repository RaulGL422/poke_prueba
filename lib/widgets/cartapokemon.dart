import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/models/pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:poke_prueba/states.dart';

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
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Container(
                    height: 250, // Altura fija
                    color: Colors.grey[300], // Fondo gris
                    child: CachedNetworkImage(
                      imageUrl: pokemon.photo,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover, // Ajusta la imagen para que siempre se vea bien
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        pokemon.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      IconButton(
                        onPressed: () {
                          context.read<PokemonBloc>().add(ToggleFavorite(pokemon: pokemon));
                        },
                        icon: Icon(icon),
                        color: Colors.red,
                        iconSize: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
