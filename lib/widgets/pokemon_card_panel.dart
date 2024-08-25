import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/controllers/scrollcontroller.dart';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/states.dart';
import 'package:poke_prueba/theme/theme.dart';
import 'package:poke_prueba/widgets/pokemon_card.dart';
import 'package:poke_prueba/models/pokemon.dart';

class PokemonCardPanel extends StatelessWidget {
  const PokemonCardPanel({
    super.key,
    required this.pokemonList,
    required this.state,
  });

  final List<Pokemon> pokemonList; // Lista de Pokémon a mostrar
  final PokemonState state; // Estado actual del Bloc

  @override
  Widget build(BuildContext context) {
    // Controlador de scroll personalizado para detectar cuándo se llega al final de la lista
    final scrollController = PokemonScrollController(
      onEndReached: () {
        if (state is! PokemonLoadingMore) {
          context.read<PokemonBloc>().add(LoadMorePokemons()); // Cargar más Pokémon cuando se llegue al final de la lista
        }
      },
    );

    final screenSize = MediaQuery.of(context).size;

    int numberOfColumns;
    double widthFactor;
    double spacing;

    // Configura el número de columnas, el ancho y el espaciado de la grilla según el tamaño de la pantalla
    if (screenSize.width >= 1200) { // Pantallas grandes (ordenadores)
      numberOfColumns = 3;
      widthFactor = AppFactorWidth.widthFactorComputer;
      spacing = 16;
    } else if (screenSize.width >= 728) { // Pantallas medianas (tablets)
      numberOfColumns = 2;
      widthFactor = AppFactorWidth.widthFactorTablet;
      spacing = 16;
    } else { // Pantallas pequeñas (móviles)
      numberOfColumns = 1;
      widthFactor = AppFactorWidth.widthFactorMobile;
      spacing = 12;
    }

    return Center(
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: GridView.builder(
          controller: scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: numberOfColumns, // Número de columnas en la grilla
            crossAxisSpacing: spacing, // Espaciado horizontal entre columnas
            mainAxisSpacing: spacing, // Espaciado vertical entre filas
          ),
          itemCount: pokemonList.length,
          itemBuilder: (context, index) {
            final pokemon = pokemonList[index];

            // Retorna la carta del Pokémon con animaciones de opacidad y escala
            return AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 300), // Duración de la animación de desvanecimiento
              child: AnimatedScale(
                scale: 1.0,
                duration: Duration(milliseconds: 300), // Duración de la animación de escala
                child: PokemonCard(pokemon: pokemon),
              ),
            );
          },
        ),
      ),
    );
  }
}
