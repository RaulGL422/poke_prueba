import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/states.dart';

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
    return Column(
      children: [
        Expanded(
            child: BlocBuilder<PokemonBloc, PokemonState>(
              builder: (context, state) {
                if (state is PokemonLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PokemonLoaded) {
                  return PanelCartas(
                    pokemonList: state.pokemonList
                  );
                } else if (state is PokemonError) {
                  return Center(child: Text(state.message));
                } else {
                  return Center(child: Text("No hay pokemons disponibles"));
                }
              }
            )
        ),
        Center(
          child: ElevatedButton(
            onPressed: () => context.read<PokemonBloc>().add(LoadMorePokemons()),
            child: Text("Ver mas"),
          ),
        )
      ],
    );
  }
}

class Pokemon {
  Pokemon({
    required this.nombre,
    required this.photo,
    required this.habilidades,
  });

  String nombre;
  String photo;
  List<String> habilidades;
  bool favorite = false;

    @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pokemon && other.nombre == nombre;
  }

  @override
  int get hashCode => nombre.hashCode;
  
}

// Formacion de cada una de las cartas mostradas
class CartaPokemon extends StatelessWidget {
  const CartaPokemon({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    if (pokemon.favorite) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    return BlocBuilder<PokemonBloc, PokemonState> (
        builder: (context, state) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(pokemon.photo), // Cargar la imagen desde la URL
                const SizedBox(height: 10),
                Text(
                  pokemon.nombre,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => context.read<PokemonBloc>()..add(ToggleFavorite(pokemon: pokemon)),
                  icon: Icon(icon)
                )
              ],
            ),
          );
        }
      );
  }
}

// Se encarga de mostrar todo el panel de cartas
class PanelCartas extends StatelessWidget {
  const PanelCartas({
    super.key,
    required this.pokemonList
  });

  final Set<Pokemon> pokemonList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.7, // Maximo de pantalla usado 70%
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Columnas
              crossAxisSpacing: 16,
              mainAxisSpacing: 16
            ),
            itemCount: pokemonList.length,
            itemBuilder: (context, index) {
              return CartaPokemon(pokemon: pokemonList.elementAt(index));
            }
          )
        )
      )
    );
  }

}