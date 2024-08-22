import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/states.dart';
import 'package:poke_prueba/widgets/filterbar.dart';
import 'package:poke_prueba/widgets/panelcartas.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Center(child: const Text("Poke Prueba")),
          ),
          body: Column(
            children: [
              FilterBar(),
              
              // Mostrar PanelCartas cuando los datos se han cargado
              if (state is PokemonLoaded)
                Expanded(
                  child: PanelCartas(pokemonList: state.pokemonList, state: state),
                ),

              if (state is PokemonLoadingMore)
                Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()),

              // Mostrar indicador de carga principal si estamos cargando los Pokémon iniciales
              if (state is PokemonLoading)
                Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
              
              // Mostrar mensaje de error
              if (state is PokemonError)
                Expanded(
                  child: Center(child: Text(state.message)),
                ),

              // Mostrar mensaje predeterminado si no hay pokémon disponibles
              if (state is PokemonInitial || state is PokemonError && !state.message.isNotEmpty)
                Expanded(
                  child: Center(child: Text("No hay pokemons disponibles")),
                ),
            ],
          ),
        );
      },
    );
  }
}
