import 'package:poke_prueba/main.dart';

abstract class PokemonState {
  const PokemonState();
}

class PokemonInitial extends PokemonState {}

class PokemonLoading extends PokemonState {}

class PokemonLoaded extends PokemonState {
  final Set<Pokemon> pokemonList;

  const PokemonLoaded({
    required this.pokemonList
  });
}

class PokemonError extends PokemonState {
  final String message;
  
  const PokemonError({
    required this.message
  });
}