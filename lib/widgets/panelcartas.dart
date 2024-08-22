import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/controllers/scrollcontroller.dart';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/states.dart';
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
          context.read<PokemonBloc>().add(LoadMorePokemons());
        }
      },
    );
    
    final sizeScreen = MediaQuery.of(context).size;

    int columns;
    double widthFactor;
    double spacing;

    if (sizeScreen.width >= 1200) { // Ordenador
      columns = 4;
      widthFactor = 0.8;
      spacing = 16;
    } else if (sizeScreen.width >= 800) { // Tablet
      columns = 3;
      widthFactor = 0.7;
      spacing = 16;
    } else { // Moviles
      columns = 1;
      widthFactor = 0.9;
      spacing = 12;
    }

    return Center(
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: GridView.builder(
          controller: scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: pokemonList.length,
          itemBuilder: (context, index) {
            final pokemon = pokemonList[index];

            // Animación de Fade y Scale
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
