import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/models/pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:poke_prueba/states.dart';
import 'package:poke_prueba/models/type.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        // Verificar si el Pokémon es favorito
        final bool isFavorite = context.read<PokemonBloc>().favoritePokemons.contains(pokemon);

        return GestureDetector(
          onTap: () {
            // Seleccionar el Pokémon al hacer clic
            context.read<PokemonBloc>().add(SelectPokemon(selectedPokemon: pokemon));
          },
          child: Card(
            color: const Color.fromARGB(255, 174, 147, 147),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Esquinas redondeadas para la tarjeta
            ),
            elevation: 6, // Elevación de la tarjeta para crear una sombra
            margin: const EdgeInsets.all(4), // Margen alrededor de la tarjeta
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calcular la altura de la imagen como el 45% de la altura total de la tarjeta
                final double imageHeight = constraints.maxHeight * 0.45;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icono de favorito en la esquina superior derecha
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Añadir o eliminar de favoritos
                            context.read<PokemonBloc>().add(ToggleFavorite(pokemon: pokemon));
                          },
                          icon: Icon(
                            isFavorite ? Icons.star : Icons.star_border, // Estrella llena o vacía según favorito
                          ),
                          color: isFavorite ? Colors.yellow : Colors.white, // Cambiar el color del icono según favorito
                          iconSize: 50, // Tamaño del icono
                        ),
                      ],
                    ),
                    // Imagen del Pokémon con esquinas redondeadas
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Esquinas redondeadas para la imagen
                      child: CachedNetworkImage(
                        imageUrl: pokemon.photo, // URL de la imagen del Pokémon
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(), // Indicador de carga mientras se descarga la imagen
                        ),
                        height: imageHeight, // Altura de la imagen basada en el tamaño de la tarjeta
                        fit: BoxFit.cover, // Ajusta la imagen para cubrir todo el espacio disponible
                      ),
                    ),
                    // Nombre del Pokémon
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        pokemon.name, // Nombre del Pokémon
                        style: const TextStyle(
                          fontSize: 22, // Tamaño de la fuente
                          fontWeight: FontWeight.bold, // Texto en negrita
                          color: Colors.white, // Color del texto
                        ),
                        textAlign: TextAlign.center, // Centrar el texto
                      ),
                    ),
                    // Tipos de Pokémon mostrados como Chips
                    Wrap(
                      spacing: 8.0, // Espaciado horizontal entre los chips
                      runSpacing: 4.0, // Espaciado vertical entre los chips
                      alignment: WrapAlignment.center, // Centrar los chips
                      children: pokemon.types.map((type) {
                        final pokemonType = Type.values.firstWhere(
                          (typeEnum) => typeEnum.name.toLowerCase() == type.toLowerCase(),
                        ); // Encuentra el tipo correspondiente en el enumerado
                        return Chip(
                          label: Text(
                            type, // Nombre del tipo de Pokémon
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: pokemonType.color, // Color del Chip basado en el tipo de Pokémon
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
