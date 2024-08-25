import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/models/pokemon.dart';
import 'package:poke_prueba/states.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  // URL base de la API de Pokémon
  final String apiUrl = "https://pokeapi.co/api/v2/pokemon";
  final int pokemonsPerPage = 20; // Cantidad de Pokémon a mostrar por página

  List<Pokemon> allPokemons = []; // Lista de todos los Pokémon cargados con detalles
  List<Pokemon> displayedPokemons = []; // Lista de Pokémon actualmente mostrados en la UI
  List<Pokemon> favoritePokemons = []; // Lista de Pokémon marcados como favoritos
  List<Pokemon> filteredPokemons = []; // Lista de Pokémon filtrados por nombre

  bool isFavoriteFilterEnabled = false; // Indica si el filtro de favoritos está activo
  bool isNameFilterEnabled = false; // Indica si el filtro de nombre está activo

  PokemonBloc() : super(PokemonInitial()) {
    on<LoadPokemons>(loadInitialPokemons);
    on<LoadMorePokemons>(loadMorePokemons);
    on<ToggleFavorite>(toggleFavoriteStatus);
    on<ToggleFavoriteFilter>(toggleFavoriteFilter);
    on<FilterName>(filterPokemonsByName);
    on<SelectPokemon>(selectPokemon);
    on<ClearFilter>(clearActiveFilters);
    on<ClearSelection>(clearPokemonSelection);
  }

  // Maneja la carga inicial de Pokémon desde la API
  Future<void> loadInitialPokemons(
    LoadPokemons event,
    Emitter<PokemonState> emit,
  ) async {
    emit(PokemonLoading());
    try {
      await fetchAllPokemonData(); // Obtiene la lista de todos los Pokémon desde la API
      await loadPokemonDetails(offset: 0, limit: pokemonsPerPage); // Carga los detalles de los primeros Pokémon
      emit(PokemonLoaded(pokemonList: displayedPokemons));
    } catch (e) {
      emit(PokemonError(message: e.toString()));
    }
  }

  // Maneja la carga de más Pokémon cuando el usuario hace scroll en la lista
  Future<void> loadMorePokemons(
    LoadMorePokemons event,
    Emitter<PokemonState> emit,
  ) async {
    // Solo carga más Pokémon si no hay filtros activos
    if (!isFavoriteFilterEnabled && !isNameFilterEnabled) {
      emit(PokemonLoadingMore(pokemonList: displayedPokemons));
      try {
        int nextOffset = displayedPokemons.length;
        await loadPokemonDetails(offset: nextOffset, limit: pokemonsPerPage);
        emit(PokemonLoaded(pokemonList: displayedPokemons));
      } catch (e) {
        emit(PokemonError(message: e.toString()));
      }
    }
  }

  // Marca o desmarca un Pokémon como favorito
  void toggleFavoriteStatus(
    ToggleFavorite event,
    Emitter<PokemonState> emit,
  ) {
    if (favoritePokemons.contains(event.pokemon)) {
      favoritePokemons.remove(event.pokemon);
    } else {
      favoritePokemons.add(event.pokemon);
    }

    // Si un Pokémon está seleccionado, emite su estado actualizado
    if (state is PokemonSelectedState) {
      emit(PokemonSelectedState(pokemon: event.pokemon));
    } else {
      emit(PokemonLoaded(
          pokemonList: (isFavoriteFilterEnabled
              ? favoritePokemons
              : isNameFilterEnabled
                  ? filteredPokemons
                  : displayedPokemons)));
    }
  }

  // Obtiene la lista completa de Pokémon desde la API (solo los nombres y URLs)
  Future<void> fetchAllPokemonData() async {
    final response = await http.get(Uri.parse("$apiUrl?limit=1118"));
    var jsonData = json.decode(response.body);
    List results = jsonData['results'];
    allPokemons = results.map((result) {
      return Pokemon(name: capitalize(result["name"]), url: result["url"]);
    }).toList();
  }

  // Capitaliza la primera letra de cada palabra en el nombre del Pokémon
  String capitalize(String name) {
    return name
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  // Carga los detalles de un rango específico de Pokémon
  Future<void> loadPokemonDetails({
    required int offset,
    required int limit,
  }) async {
    final fetches = <Future<Pokemon>>[];

    for (var i = offset; i < offset + limit && i < allPokemons.length; i++) {
      if (!allPokemons[i].loadedDetails) {
        fetches.add(fetchPokemonDetail(allPokemons[i]));
      } else {
        displayedPokemons.add(allPokemons[i]);
      }
    }
    final fetchedPokemons = await Future.wait(fetches);
    displayedPokemons.addAll(fetchedPokemons);
  }

  // Obtiene los detalles completos de un Pokémon específico desde la API
  Future<Pokemon> fetchPokemonDetail(Pokemon pokemon) async {
    final response = await http.get(Uri.parse(pokemon.url)); // URL específica de un Pokémon
    var pokemonData = json.decode(response.body);

    pokemon.numPokedex = pokemonData["id"];
    pokemon.photo = pokemonData["sprites"]["front_default"]; // URL de la imagen del Pokémon
    pokemon.habilities = (pokemonData["abilities"] as List)
        .map((ability) => capitalize(ability["ability"]["name"]))
        .toList();
    pokemon.types = (pokemonData["types"] as List)
        .map((type) => capitalize(type["type"]["name"]))
        .toList();

    pokemon.loadedDetails = true;

    return pokemon;
  }

  // Activa o desactiva el filtro de Pokémon favoritos
  void toggleFavoriteFilter(
    ToggleFavoriteFilter event,
    Emitter<PokemonState> emit,
  ) {
    isFavoriteFilterEnabled = !isFavoriteFilterEnabled;

    // Aplica el filtro de favoritos y también el filtro por nombre si está activo
    final filtered = isNameFilterEnabled
        ? filteredPokemons.where((pokemon) => isFavoriteFilterEnabled
            ? favoritePokemons.contains(pokemon)
            : allPokemons.contains(pokemon)).toList()
        : (isFavoriteFilterEnabled ? favoritePokemons : allPokemons);

    emit(PokemonLoaded(pokemonList: filtered));
  }

  // Limpia todos los filtros activos y muestra la lista completa o los favoritos
  void clearActiveFilters(
    ClearFilter event,
    Emitter<PokemonState> emit,
  ) {
    isNameFilterEnabled = false;
    emit(PokemonLoaded(
        pokemonList: (isFavoriteFilterEnabled
            ? favoritePokemons
            : displayedPokemons)));
  }

  // Filtra la lista de Pokémon por nombre
  Future<void> filterPokemonsByName(
    FilterName event,
    Emitter<PokemonState> emit,
  ) async {
    if (event.name.isNotEmpty) {
      isNameFilterEnabled = true;
      emit(PokemonLoading());

      try {
        filteredPokemons = (isFavoriteFilterEnabled ? favoritePokemons : allPokemons)
            .where((pokemon) => pokemon.name
                .toLowerCase()
                .contains(event.name.trim().toLowerCase()))
            .toList();

        // Carga los detalles de los Pokémon filtrados si aún no están cargados
        final fetches = filteredPokemons
            .where((pokemon) => !pokemon.loadedDetails)
            .map((pokemon) => fetchPokemonDetail(pokemon));

        await Future.wait(fetches);

        emit(PokemonLoaded(pokemonList: filteredPokemons));
      } catch (e) {
        emit(PokemonError(message: e.toString()));
      }
    } else {
      isNameFilterEnabled = false;
    }
  }

  // Maneja la selección de un Pokémon específico
  void selectPokemon(
    SelectPokemon event,
    Emitter<PokemonState> emit,
  ) {
    emit(PokemonSelectedState(pokemon: event.selectedPokemon));
  }

  // Limpia la selección actual y vuelve a la lista de Pokémon mostrados
  void clearPokemonSelection(
    ClearSelection event,
    Emitter<PokemonState> emit,
  ) {
    emit(PokemonLoaded(pokemonList: isNameFilterEnabled ? filteredPokemons : isFavoriteFilterEnabled ? favoritePokemons : displayedPokemons));

  }
}
