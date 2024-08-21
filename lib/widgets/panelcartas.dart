import 'package:flutter/material.dart';
import 'package:poke_prueba/widgets/cartapokemon.dart';
import '../models/pokemon.dart';

class PanelCartas extends StatelessWidget {
  const PanelCartas({
    super.key,
    required this.pokemonList,
  });

  final List<Pokemon> pokemonList;

  @override
  Widget build(BuildContext context) {
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
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: pokemonList.length,
          itemBuilder: (context, index) {
            return CartaPokemon(pokemon: pokemonList.elementAt(index));
          },
        ),
      ),
    );
  }
}
