import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/states.dart';
import 'package:poke_prueba/main.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final String url = "https://pokeapi.co/api/v2/pokemon";
  final int pokemonCharged = 10; // Pokemons nuevos cada vez

  int offset = 0; // Limitador
  Set<Pokemon> pokemonList = {};

  PokemonBloc() : super(PokemonInitial()) {
    on<LoadPokemons>(onLoadPokemons);
    on<LoadMorePokemons>(onLoadMorePokemons);
    on<ToggleFavorite>(onToggleFavorite);
  }

  Future<void> onLoadPokemons(
    LoadPokemons event,
    Emitter<PokemonState> emit
  ) async {
    emit(PokemonLoading());
    try {
      final pokemons = await obtainPokemons(offset);
      emit(PokemonLoaded(pokemonList: pokemons));
    } catch (e) {
      emit(PokemonError(message: e.toString()));
    }
  }

  Future<void> onLoadMorePokemons(
    LoadMorePokemons event,
    Emitter<PokemonState> emit
  ) async {
    try {
      offset += pokemonCharged; // Incrementar el offset para cargar más
      final pokemons = await obtainPokemons(offset);
      emit(PokemonLoaded(pokemonList: pokemons));
    } catch (e) {
      emit(PokemonError(message: e.toString()));
    }
  }

  void onToggleFavorite(
    ToggleFavorite event,
    Emitter<PokemonState> emit
  ) {
    Pokemon? pokemon = pokemonList.lookup(event.pokemon);
    if (pokemon != null) {
      pokemon.favorite = !pokemon.favorite;
    }
    emit(PokemonLoaded(pokemonList: pokemonList));
  }

  Future<Set<Pokemon>> obtainPokemons(int offset) async {
    final globalResponse = await http.get(Uri.parse("$url?limit=$pokemonCharged&offset=$offset")); // Datos Globales
    var globalData = json.decode(globalResponse.body);
    List results = globalData['results'];

    // Realizar las peticiones en paralelo
    await Future.wait(results.map((result) => obtainPokemonDetail(result["url"])));

    return pokemonList;
  }

  Future<void> obtainPokemonDetail(String url) async {
    final response = await http.get(Uri.parse(url)); // Datos del pokemon
    var pokemonData = json.decode(response.body);

    Pokemon pokemon = Pokemon(
      nombre: pokemonData["name"],
      photo: pokemonData["sprites"]["front_default"],
      habilidades: (pokemonData["abilities"] as List)
          .map((habilidad) => habilidad["ability"]["name"] as String)
          .toList(),
    );

    pokemonList.add(pokemon);
  }
}
