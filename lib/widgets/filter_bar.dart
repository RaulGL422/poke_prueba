import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/theme/theme.dart';

class FilterBar extends StatelessWidget {
  const FilterBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    // Ajusta el widthFactor según el tamaño de la pantalla
    final double widthFactor = screenSize.width >= 1200
        ? AppFactorWidth.widthFactorComputer // Ordenador
        : screenSize.width >= 800
            ? AppFactorWidth.widthFactorTablet // Tablet
            : AppFactorWidth.widthFactorMobile; // Móviles

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
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          onSubmitted: (text) {
                            context.read<PokemonBloc>().add(FilterName(name: text));
                          },
                          decoration: InputDecoration(
                            hintText: 'Filtrar nombre',
                            hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                            contentPadding: const EdgeInsets.all(8),
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
                        child: const Text("Limpiar"),
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
                context.read<PokemonBloc>().isFavoriteFilterEnabled
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
