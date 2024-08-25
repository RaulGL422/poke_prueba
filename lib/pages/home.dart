import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/pages/pokemon_detail.dart';
import 'package:poke_prueba/states.dart';
import 'package:poke_prueba/widgets/filter_bar.dart';
import 'package:poke_prueba/widgets/pokemon_card_panel.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        // Mostrar la página de detalles si hay un Pokémon seleccionado
        if (state is PokemonSelectedState) {
          return PokemonDetailsPage(pokemon: state.pokemon);
        }

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            title: const Center(child: Text("Poke Prueba")),
            foregroundColor: theme.textTheme.bodyMedium?.color,
          ),
          body: Column(
            children: [
              const FilterBar(), // Barra de filtros

              if (state is PokemonLoaded && state.pokemonList.isNotEmpty)
                Expanded(
                  child: PokemonCardPanel(
                    pokemonList: state.pokemonList,
                    state: state,
                  ),
                ), // Panel de tarjetas de Pokémon

              if (state is PokemonLoadingMore)
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(), // Indicador de carga adicional
                ),

              if (state is PokemonLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()), // Indicador de carga inicial
                ),

              if (state is PokemonError)
                Expanded(
                  child: Center(child: Text(state.message)), // Mensaje de error
                ),

              if (state is PokemonInitial || (state is PokemonError && state.message.isEmpty))
                const Expanded(
                  child: Center(child: Text("No hay pokemons disponibles")), // Mensaje cuando no hay datos
                ),
            ],
          ),
        );
      },
    );
  }
}
