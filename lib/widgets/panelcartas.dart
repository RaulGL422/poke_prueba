import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/controllers/scrollcontroller.dart';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/states.dart';
import 'package:poke_prueba/theme/theme.dart';
import 'package:poke_prueba/widgets/cartapokemon.dart';
import 'package:poke_prueba/models/pokemon.dart';

class PanelCartas extends StatelessWidget {
  const PanelCartas({
    super.key,
    required this.pokemonList,
    required this.state
  });

  final List<Pokemon> pokemonList;
  final PokemonState state;

  @override
  Widget build(BuildContext context) {
    final scrollController = PokemonScrollController(
      onEndReached: () {
        if (state is! PokemonLoadingMore) {
          context.read<PokemonBloc>().add(LoadMorePokemons()); // Carga más Pokémon al llegar al final de la lista
        }
      },
    );

    final sizeScreen = MediaQuery.of(context).size;

    int columns;
    double widthFactor;
    double spacing;

    // Configuración de columnas, ancho y espaciado según el tamaño de la pantalla
    if (sizeScreen.width >= 1200) { // Ordenador
      columns = 3;
      widthFactor = AppFactorWidth.widthFactorComputer;
      spacing = 16;
    } else if (sizeScreen.width >= 728) { // Tablet
      columns = 2;
      widthFactor = AppFactorWidth.widthFactorTablet;
      spacing = 16;
    } else { // Móviles
      columns = 1;
      widthFactor = AppFactorWidth.widthFactorMobile;
      spacing = 12;
    }

    return Center(
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: GridView.builder(
          controller: scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns, // Número de columnas en la grilla
            crossAxisSpacing: spacing, // Espaciado horizontal entre columnas
            mainAxisSpacing: spacing, // Espaciado vertical entre filas
          ),
          itemCount: pokemonList.length,
          itemBuilder: (context, index) {
            final pokemon = pokemonList[index];

            // Aplicación de animación de opacidad y escala a las cartas
            return AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 300), // Duración de la animación de desvanecimiento
              child: AnimatedScale(
                scale: 1.0,
                duration: Duration(milliseconds: 300), // Duración de la animación de escala
                child: CartaPokemon(pokemon: pokemon),
              ),
            );
          },
        ),
      ),
    );
  }
}
