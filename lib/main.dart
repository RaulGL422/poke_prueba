import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainState(),
      child: MaterialApp(
        
        title: 'Poke Prueba',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: HomePage(),
      ),
    );
  }
}

class MainState extends ChangeNotifier {
  final String url = "https://pokeapi.co/api/v2/pokemon";
  
  List<Pokemon> listaPokemons = [];

  Future<void> recargarListadoPokemons() async {
    final respuesta = await http.get(Uri.parse(url));
    var datos = json.decode(respuesta.body);
    List results = datos['results'];
    for (var dato in results) {
      var datosActual = await http.get(Uri.parse(dato["url"]));
      var pokemonData = json.decode(datosActual.body);

      Pokemon pokemon = Pokemon(
        nombre: pokemonData["name"],
        photo: pokemonData["sprites"]["front_default"],
        habilidades: (pokemonData["abilities"] as List)
            .map((habilidad) => habilidad["ability"]["name"] as String)
            .toList(),
      );
      listaPokemons.add(pokemon);
    }

    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainState>();
    if (appState.listaPokemons.isEmpty) {
      appState.recargarListadoPokemons();
    }
    return PanelCartas(listaPokemons: appState.listaPokemons);
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
        ],
      ),
    );
  }
}

// Se encarga de mostrar todo el panel de cartas
class PanelCartas extends StatelessWidget {
  const PanelCartas({
    super.key,
    required this.listaPokemons
  });

  final List<Pokemon> listaPokemons;

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
            itemCount: listaPokemons.length,
            itemBuilder: (context, index) {
              return CartaPokemon(pokemon: listaPokemons[index]);
            }
          )
        )
      )
    );
  }

}