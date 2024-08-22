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
  final int pokemonPerPage = 20; // Cantidad de Pokémon a mostrar por página

  List<Pokemon> pokemonList = []; // Lista de Pokémon cargados con detalles
  List<Pokemon> displayedPokemons = []; // Lista de Pokémon actualmente mostrados
  List<Pokemon> favoritePokemons = []; // Lista de Pokemon favoritos
  List<Pokemon> filteredList = [];

  bool favoriteFilter = false;
  bool nameFilter = false;

  PokemonBloc() : super(PokemonInitial()) {
    on<LoadPokemons>(onLoadPokemons);
    on<LoadMorePokemons>(onLoadMorePokemons);
    on<ToggleFavorite>(onToggleFavorite);
    on<ToggleFavoriteFilter>(onToggleFavoriteFilter);
    on<FilterName>(onFilterName);
    on<SelectPokemon>(onSelectPokemon);
    on<ClearFilter>(clearFilter);
  }

  Future<void> onLoadPokemons(
    LoadPokemons event,
    Emitter<PokemonState> emit
  ) async {
    emit(PokemonLoading());
    try {
      // Cargar lista de nombres y URLs de todos los Pokémon
      await obtainAllPokemonData();
      // Mostrar los primeros 20 Pokémon (cargar sus detalles bajo demanda)
      await loadPokemonDetails(offset: 0, limit: pokemonPerPage);
      emit(PokemonLoaded(pokemonList: displayedPokemons));
    } catch (e) {
      emit(PokemonError(message: e.toString()));
    }
  }

  Future<void> onLoadMorePokemons(
    LoadMorePokemons event,
    Emitter<PokemonState> emit
  ) async {
    if (!favoriteFilter && !nameFilter) {
      emit(PokemonLoadingMore(pokemonList: displayedPokemons));
      try {
        // Calcular el siguiente conjunto de Pokémon a mostrar
        int nextOffset = displayedPokemons.length;
        await loadPokemonDetails(offset: nextOffset, limit: pokemonPerPage);
        emit(PokemonLoaded(pokemonList: displayedPokemons));
      } catch (e) {
        emit(PokemonError(message: e.toString()));
      }
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

    emit(PokemonLoaded(pokemonList: favoriteFilter ? favoritePokemons : displayedPokemons));
  }

  Future<void> obtainAllPokemonData() async {
    final globalResponse = await http.get(Uri.parse("$url?limit=1118")); // Obtener lista de nombres y URLs de todos los Pokémon
    var globalData = json.decode(globalResponse.body);
    List results = globalData['results'];

    pokemonList = results.map(((result) {
      return Pokemon(name: capitalize(result["name"]), url: result["url"]);
    })).toList();
  }

  String capitalize(String name) {
    return name.split('-').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  Future<void> loadPokemonDetails({required int offset, required int limit}) async {
    for (var i = offset; i < offset + limit; i++) {
      Pokemon pokemon = await obtainPokemonDetail(pokemonList.elementAt(i));
      displayedPokemons.add(pokemon);
    }
  }

  Future<Pokemon> obtainPokemonDetail(Pokemon pokemon) async {
    final response = await http.get(Uri.parse(pokemon.url)); // Datos del Pokémon
    var pokemonData = json.decode(response.body);

    pokemon.numPokedex = pokemonData["id"];
    pokemon.photo = pokemonData["sprites"]["front_default"];
    pokemon.habilities = (pokemonData["abilities"] as List)
          .map((habilidad) => capitalize(habilidad["ability"]["name"]))
          .toList();
    pokemon.types = (pokemonData["types"] as List)
      .map((type) => capitalize(type["type"]["name"]))
      .toList();

    return pokemon;
  }

  void onToggleFavoriteFilter(
    ToggleFavoriteFilter event,
    Emitter<PokemonState> emit
  ) {
    if (favoriteFilter) {
      emit(PokemonLoaded(pokemonList: nameFilter
        ? filteredList.where(
            (pokemon) => pokemonList.contains(pokemon)
          ).toList() 
        : pokemonList)
      );
    } else {
      emit(PokemonLoaded(pokemonList: nameFilter 
        ? filteredList.where(
            (pokemon) => favoritePokemons.contains(pokemon)
          ).toList() 
        : favoritePokemons)
      );
    }
    favoriteFilter = !favoriteFilter;
  }

  void clearFilter(
    ClearFilter event,
    Emitter<PokemonState> emit
  ) {
    nameFilter = false;
    emit(PokemonLoaded(pokemonList: favoriteFilter ? favoritePokemons : displayedPokemons));
  }

  Future<void> onFilterName(
    FilterName event,
    Emitter<PokemonState> emit
  ) async {
    if (event.name.isNotEmpty) {
      nameFilter = true;
      emit(PokemonLoading());
      try {
        if (favoriteFilter) {
          filteredList = favoritePokemons.where(
            (pokemon) => pokemon.name.toLowerCase().contains(event.name.trim().toLowerCase())
          ).toList();
        } else {
          filteredList = pokemonList.where(
            (pokemon) => pokemon.name.toLowerCase().contains(event.name.trim().toLowerCase())
          ).toList();
        }
        

        for (int i = 0; i < filteredList.length; i++) {
          filteredList[i] = await obtainPokemonDetail(filteredList[i]);
        }

        emit(PokemonLoaded(pokemonList: filteredList));
      } catch (e) {
        emit(PokemonError(message: e.toString()));
      }
    } else {
      nameFilter = false;
    }
  }

  void onSelectPokemon(
    SelectPokemon event,
    Emitter<PokemonState> emit
  ) {
    Navigator.push(
      event.context,
      MaterialPageRoute(
        builder: (context) => PokemonDetailsPage(pokemon: event.selectedPokemon),
      ),
    );
  }
}
