import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/models/pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:poke_prueba/states.dart';
import 'package:poke_prueba/models/type.dart';

class CartaPokemon extends StatelessWidget {
  final Pokemon pokemon;

  const CartaPokemon({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    print("Creando carta $pokemon");

    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        final isFavorite = context
            .read<PokemonBloc>()
            .favoritePokemons
            .contains(pokemon); // Verifica si el Pokémon es favorito

        return GestureDetector(
          onTap: () {
            context
                .read<PokemonBloc>()
                .add(SelectPokemon(selectedPokemon: pokemon)); // Selecciona el Pokémon al hacer clic
          },
          child: Card(
            color: const Color.fromARGB(255, 174, 147, 147),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Esquina redondeada de la carta
            ),
            elevation: 6, // Elevación de la carta para darle sombra
            margin: const EdgeInsets.all(4), // Margen alrededor de la carta
            child: LayoutBuilder(
              builder: (context, constraints) {
                final imageHeight = constraints.maxHeight * 0.45; // Obtener el 45% de la card

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            context.read<PokemonBloc>().add(
                                ToggleFavorite(
                                    pokemon: pokemon)); // Marca o desmarca como favorito
                          },
                          icon: Icon(
                              isFavorite ? Icons.star : Icons.star_border), // Icono de estrella (llena o vacía)
                          color: isFavorite ? Colors.yellow : Colors.white, // Color del icono según sea favorito o no
                          iconSize: 50, // Tamaño del icono
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Esquinas redondeadas para la imagen
                      child: CachedNetworkImage(
                        imageUrl: pokemon.photo, // URL de la imagen del Pokémon
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(), // Indicador de carga mientras se descarga la imagen
                        ),
                        height: imageHeight, // Ajusta la altura de la imagen al 65% de la Card
                        fit: BoxFit.cover, // Ajusta la imagen para cubrir todo el espacio disponible
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        pokemon.name, // Nombre del Pokémon
                        style: const TextStyle(
                          fontSize: 22, // Tamaño del texto
                          fontWeight: FontWeight.bold, // Texto en negrita
                          color: Colors.white, // Color del texto
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      alignment: WrapAlignment.center,
                      children: pokemon.types.map((type) {
                        final typeEnum = Type.values.firstWhere((e) =>
                            e.name.toLowerCase() ==
                            type.toLowerCase()); // Encuentra el tipo correspondiente en el enumerado
                        return Chip(
                          label: Text(
                            type, // Nombre del tipo de Pokémon
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor:
                              typeEnum.color, // Color del Chip según el tipo de Pokémon
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
