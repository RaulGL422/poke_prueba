import 'package:poke_prueba/models/pokemon.dart';

abstract class PokemonState {
  PokemonState();
}

class PokemonInitial extends PokemonState {}

class PokemonLoading extends PokemonState {}

class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemonList;
  PokemonLoaded({
    required this.pokemonList
  });
}

class PokemonError extends PokemonState {
  final String message;
  
  PokemonError({
    required this.message
  });
}