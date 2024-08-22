import 'package:flutter/material.dart';
import 'package:poke_prueba/models/pokemon.dart';

abstract class PokemonEvent {
  const PokemonEvent();
}

class LoadPokemons extends PokemonEvent {}

class LoadMorePokemons extends PokemonEvent {}

class ToggleFavorite extends PokemonEvent {
  final Pokemon pokemon; // Pokemon seleccionado
  ToggleFavorite({
    required this.pokemon
  });
}

class ToggleFavoriteFilter extends PokemonEvent {}

class FilterName extends PokemonEvent {
  final String name;
  const FilterName({
    required this.name
  });
}

class ClearFilter extends PokemonEvent {}

class SelectPokemon extends PokemonEvent {
  final Pokemon selectedPokemon;
  final BuildContext context;

  const SelectPokemon({
    required this.selectedPokemon,
    required this.context
  });

}