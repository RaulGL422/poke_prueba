import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/states.dart';
import 'package:poke_prueba/widgets/panelcartas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poke Prueba',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: BlocProvider(
        create: (_) => PokemonBloc()..add(LoadPokemons()),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        if (state is PokemonLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Pokemon"),
              actions: [
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      onChanged: (text) {
                        context.read<PokemonBloc>().add(FilterName(name: text));
                      },
                      decoration: InputDecoration(
                        hintText: 'Filtrar nombre',
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<PokemonBloc>().add(ToggleFavoriteFilter());
                  },
                  icon: Icon(context.read<PokemonBloc>().favoriteFilter
                      ? Icons.favorite
                      : Icons.favorite_border),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(child: PanelCartas(pokemonList: state.pokemonList)),
                if (!context.read<PokemonBloc>().favoriteFilter)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<PokemonBloc>().add(LoadMorePokemons());
                      },
                      child: const Text("Ver más"),
                    ),
                  ),
              ],
            ),
          );
        } else if (state is PokemonLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PokemonError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text("No hay pokemons disponibles"));
        }
      },
    );
  }
}