import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/theme/theme.dart';

class FilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
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

    return Center(
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          onSubmitted: (text) {
                            context.read<PokemonBloc>().add(FilterName(name: text));
                          },
                          decoration: InputDecoration(
                            hintText: 'Filtrar nombre',
                            hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                            contentPadding: EdgeInsets.all(8),
                          ),
                          style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                        ),
                      ),
                    ),
          
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<PokemonBloc>().add(ClearFilter());
                        },
                        child: Text("Limpiar"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            IconButton(
              onPressed: () {
                context.read<PokemonBloc>().add(ToggleFavoriteFilter());
              },
              icon: Icon(
                context.read<PokemonBloc>().favoriteFilter
                    ? Icons.star
                    : Icons.star_border,
              ),
              color: Colors.yellow,
              iconSize: 40,
            ),
          ],
        ),
      ),
    );
  }
}
