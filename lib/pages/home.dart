import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/pages/pokemon_detail.dart';
import 'package:poke_prueba/states.dart';
import 'package:poke_prueba/widgets/filterbar.dart';
import 'package:poke_prueba/widgets/panelcartas.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        print("Renderizando");

        // Si hay un Pokémon seleccionado, muestra la página de detalles
        if (state is PokemonSelectedState) {
          return PokemonDetailsPage(pokemon: state.pokemon);
        }

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Center(child: const Text("Poke Prueba")),
            foregroundColor: theme.textTheme.bodyMedium?.color,
          ),
          body: Column(
            children: [
              FilterBar(), // Barra de filtrado

              if (state is PokemonLoaded && state.pokemonList.isNotEmpty)
                Expanded(
                  child: PanelCartas(pokemonList: state.pokemonList, state: state),
                ), // Panel con la lista de Pokémon

              if (state is PokemonLoadingMore)
                Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(), // Indicador de carga adicional
                ),

              if (state is PokemonLoading)
                Expanded(
                  child: Center(child: CircularProgressIndicator()), // Indicador de carga inicial
                ),

              if (state is PokemonError)
                Expanded(
                  child: Center(child: Text(state.message)), // Mensaje de error
                ),

              if (state is PokemonInitial || (state is PokemonError && !state.message.isNotEmpty))
                Expanded(
                  child: Center(child: Text("No hay pokemons disponibles")), // Mensaje cuando no hay datos
                ),
            ],
          ),
        );
      },
    );
  }
}
