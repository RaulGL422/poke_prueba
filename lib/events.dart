import 'package:poke_prueba/main.dart';

abstract class PokemonEvent {
  const PokemonEvent();
}

class LoadPokemons extends PokemonEvent {}

class LoadMorePokemons extends PokemonEvent {}

class ToggleFavorite extends PokemonEvent {
  final Pokemon pokemon;
  const ToggleFavorite({
    required this.pokemon
  });
}