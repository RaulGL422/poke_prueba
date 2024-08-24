import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:poke_prueba/events.dart';
import 'package:poke_prueba/models/pokemon.dart';
import 'package:poke_prueba/states.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final String url = "https://pokeapi.co/api/v2/pokemon";
  final int pokemonPerPage = 20; // Cantidad de Pokémon a mostrar por página

  List<Pokemon> pokemonList = []; // Lista de Pokémon cargados con detalles
  List<Pokemon> displayedPokemons = []; // Lista de Pokémon actualmente mostrados
  List<Pokemon> favoritePokemons = []; // Lista de Pokémon favoritos
  List<Pokemon> filteredList = []; // Lista de Pokémon filtrados por nombre

  bool favoriteFilter = false; // Bandera para saber si el filtro de favoritos está activado
  bool nameFilter = false; // Bandera para saber si el filtro de nombre está activado

  PokemonBloc() : super(PokemonInitial()) {
    on<LoadPokemons>(onLoadPokemons);
    on<LoadMorePokemons>(onLoadMorePokemons);
    on<ToggleFavorite>(onToggleFavorite);
    on<ToggleFavoriteFilter>(onToggleFavoriteFilter);
    on<FilterName>(onFilterName);
    on<SelectPokemon>(onSelectPokemon);
    on<ClearFilter>(clearFilter);
    on<ClearSelection>(clearSelection);
  }

  // Maneja la carga inicial de Pokémon
  Future<void> onLoadPokemons(
    LoadPokemons event,
    Emitter<PokemonState> emit,
  ) async {
    emit(PokemonLoading());
    try {
      await obtainAllPokemonData(); // Obtiene la lista de todos los Pokémon desde la API
      await loadPokemonDetails(offset: 0, limit: pokemonPerPage); // Carga los detalles de los primeros Pokémon
      emit(PokemonLoaded(pokemonList: displayedPokemons));
    } catch (e) {
      emit(PokemonError(message: e.toString()));
    }
  }

  // Maneja la carga adicional de Pokémon cuando se hace scroll
  Future<void> onLoadMorePokemons(
    LoadMorePokemons event,
    Emitter<PokemonState> emit,
  ) async {
    if (!favoriteFilter && !nameFilter) { // Evita cargar más si hay filtros aplicados
      emit(PokemonLoadingMore(pokemonList: displayedPokemons));
      try {
        int nextOffset = displayedPokemons.length;
        await loadPokemonDetails(offset: nextOffset, limit: pokemonPerPage);
        emit(PokemonLoaded(pokemonList: displayedPokemons));
      } catch (e) {
        emit(PokemonError(message: e.toString()));
      }
    }
  }

  // Marca o desmarca un Pokémon como favorito
  void onToggleFavorite(
    ToggleFavorite event,
    Emitter<PokemonState> emit,
  ) {
    if (favoritePokemons.contains(event.pokemon)) {
      favoritePokemons.remove(event.pokemon);
    } else {
      favoritePokemons.add(event.pokemon);
    }

    // Si se seleccionó un Pokémon y se actualiza su estado, se vuelve a emitir ese estado
    if (state is PokemonSelectedState) {
      emit(PokemonSelectedState(pokemon: event.pokemon));
    } else {
      emit(PokemonLoaded(
          pokemonList: (favoriteFilter
              ? favoritePokemons
              : nameFilter
                  ? filteredList
                  : displayedPokemons)));
    }
  }

  // Obtiene la lista completa de Pokémon (solo los nombres y URLs)
  Future<void> obtainAllPokemonData() async {
    final response = await http.get(Uri.parse("$url?limit=1118"));
    var globalData = json.decode(response.body);
    List results = globalData['results'];
    pokemonList = results.map((result) {
      return Pokemon(name: capitalize(result["name"]), url: result["url"]);
    }).toList();
  }

  // Capitaliza cada palabra en el nombre del Pokémon
  String capitalize(String name) {
    return name
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  // Carga los detalles de un rango de Pokémon
  Future<void> loadPokemonDetails(
      {required int offset, required int limit}) async {
    final fetches = <Future<Pokemon>>[];

    for (var i = offset; i < offset + limit && i < pokemonList.length; i++) {
      if (!pokemonList[i].loadedDetails) {
        fetches.add(obtainPokemonDetail(pokemonList[i]));
      } else {
        displayedPokemons.add(pokemonList[i]);
      }
    }
    final fetchedPokemons = await Future.wait(fetches);
    displayedPokemons.addAll(fetchedPokemons);
  }

  // Obtiene los detalles completos de un Pokémon específico
  Future<Pokemon> obtainPokemonDetail(Pokemon pokemon) async {
    final response = await http.get(Uri.parse(pokemon.url)); // URL específica de un Pokémon
    var pokemonData = json.decode(response.body);

    pokemon.numPokedex = pokemonData["id"];
    pokemon.photo = pokemonData["sprites"]["front_default"]; // URL de la imagen del Pokémon
    pokemon.habilities = (pokemonData["abilities"] as List)
        .map((habilidad) => capitalize(habilidad["ability"]["name"]))
        .toList();
    pokemon.types = (pokemonData["types"] as List)
        .map((type) => capitalize(type["type"]["name"]))
        .toList();

    pokemon.loadedDetails = true;

    return pokemon;
  }

  // Activa o desactiva el filtro de Pokémon favoritos
  void onToggleFavoriteFilter(
    ToggleFavoriteFilter event,
    Emitter<PokemonState> emit,
  ) {
    favoriteFilter = !favoriteFilter;

    // Si también hay un filtro por nombre, aplica ambos filtros
    final filtered = nameFilter
        ? filteredList
            .where((pokemon) => favoriteFilter
                ? favoritePokemons.contains(pokemon)
                : pokemonList.contains(pokemon))
            .toList()
        : (favoriteFilter ? favoritePokemons : pokemonList);

    emit(PokemonLoaded(pokemonList: filtered));
  }

  // Limpia todos los filtros aplicados
  void clearFilter(
    ClearFilter event,
    Emitter<PokemonState> emit,
  ) {
    nameFilter = false;
    emit(PokemonLoaded(
        pokemonList: (favoriteFilter ? favoritePokemons : displayedPokemons)));
  }

  // Filtra la lista de Pokémon por nombre
  Future<void> onFilterName(
    FilterName event,
    Emitter<PokemonState> emit,
  ) async {
    if (event.name.isNotEmpty) {
      nameFilter = true;
      emit(PokemonLoading());

      try {
        filteredList = (favoriteFilter ? favoritePokemons : pokemonList)
            .where((pokemon) => pokemon.name
                .toLowerCase()
                .contains(event.name.trim().toLowerCase()))
            .toList();

        // Si algún Pokémon filtrado no tiene detalles cargados, los carga
        final fetches = filteredList
            .where((pokemon) => !pokemon.loadedDetails)
            .map((pokemon) => obtainPokemonDetail(pokemon));

        final fetchedPokemons = await Future.wait(fetches);
        filteredList.addAll(fetchedPokemons);

        emit(PokemonLoaded(pokemonList: filteredList));
      } catch (e) {
        emit(PokemonError(message: e.toString()));
      }
    } else {
      nameFilter = false;
    }
  }

  // Maneja la selección de un Pokémon
  void onSelectPokemon(
    SelectPokemon event,
    Emitter<PokemonState> emit,
  ) {
    emit(PokemonSelectedState(pokemon: event.selectedPokemon));
  }

  // Limpia la selección actual y vuelve a la lista de Pokémon
  void clearSelection(
    ClearSelection event,
    Emitter<PokemonState> emit,
  ) {
    emit(PokemonLoaded(pokemonList: displayedPokemons));
  }
}
