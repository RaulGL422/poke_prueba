import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/models/pokemon.dart';
import 'package:poke_prueba/pages/pokemon_detail.dart';
import 'package:poke_prueba/states.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final String url = "https://pokeapi.co/api/v2/pokemon";
  final int pokemonCharged = 10; // Pokemons nuevos cada vez

  int offset = 0; // Limitador
  List<Pokemon> pokemonList = []; // Lista de pokemons
  List<Pokemon> favoritePokemons = [];

  bool favoriteFilter = false;

  List<Pokemon> sortPokemonList(List<Pokemon> list) {
    return list..sort((a, b) => a.numPokedex.compareTo(b.numPokedex));
  }

  PokemonBloc() : super(PokemonInitial()) {
    on<LoadPokemons>(onLoadPokemons);
    on<LoadMorePokemons>(onLoadMorePokemons);
    on<ToggleFavorite>(onToggleFavorite);
    on<ToggleFavoriteFilter>(onToggleFavoriteFilter);
    on<FilterName>(onFilterName);
    on<SelectPokemon>(onSelectPokemon);
  }

  Future<void> onLoadPokemons(
    LoadPokemons event,
    Emitter<PokemonState> emit
  ) async {
    emit(PokemonLoading());
    try {
      await Future.delayed(Duration(seconds: 1));
      await obtainPokemons(offset);
      emit(PokemonLoaded(pokemonList: sortPokemonList(pokemonList)));
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
      await obtainPokemons(offset);
      emit(PokemonLoaded(pokemonList: sortPokemonList(pokemonList)));
    } catch (e) {
      emit(PokemonError(message: e.toString()));
    }
  }

  void onToggleFavorite(
    ToggleFavorite event,
    Emitter<PokemonState> emit
  ) {
    if (favoritePokemons.contains(event.pokemon)) {
      favoritePokemons.remove(event.pokemon);
    } else {
      favoritePokemons.add(event.pokemon);
    }
    
    emit(PokemonLoaded(pokemonList: favoriteFilter ? favoritePokemons : pokemonList));
  }

  Future<void> obtainPokemons(int offset) async {
    final globalResponse = await http.get(Uri.parse("$url?limit=$pokemonCharged&offset=$offset")); // Datos Globales
    var globalData = json.decode(globalResponse.body);
    List results = globalData['results'];

    // Realizar las peticiones en paralelo
    await Future.wait(results.map((result) => obtainPokemonDetail(result["url"])));
  }

  void onToggleFavoriteFilter(
    ToggleFavoriteFilter event,
    Emitter<PokemonState> emit
  ) {
    
    if (favoriteFilter) {
      emit(PokemonLoaded(pokemonList: sortPokemonList(pokemonList)));
    } else {
      emit(PokemonLoaded(pokemonList: sortPokemonList(favoritePokemons)));
    }
    favoriteFilter = !favoriteFilter;
  }

  Future<void> obtainPokemonDetail(String url) async {
    final response = await http.get(Uri.parse(url)); // Datos del pokemon
    var pokemonData = json.decode(response.body);

    Pokemon pokemon = Pokemon(
      numPokedex: pokemonData["id"],
      name: pokemonData["name"],
      photo: pokemonData["sprites"]["front_default"],
      habilities: (pokemonData["abilities"] as List)
          .map((habilidad) => habilidad["ability"]["name"] as String)
          .toList(),
    );

    pokemonList.add(pokemon);
  }

  void onFilterName(
    FilterName event,
    Emitter<PokemonState> emit
  ) {
    List<Pokemon> listFiltered = List.from(favoriteFilter ? favoritePokemons : pokemonList);

    listFiltered.retainWhere((pokemon) => pokemon.name.contains(event.name));
    emit(PokemonLoaded(pokemonList: listFiltered));
  }
  
  void onSelectPokemon(
    SelectPokemon event,
    Emitter<PokemonState> emit
  ) {
    Navigator.push(
      event.context,
      MaterialPageRoute(
        builder: (context) => PokemonDetailsPage(pokemon: event.selectedPokemon)
      )
    );
  }
}
