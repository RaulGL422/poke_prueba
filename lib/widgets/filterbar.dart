import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/events.dart';

class FilterBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Cuadro de texto
              SizedBox(
                width: 200,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    onSubmitted: (text) {
                      context.read<PokemonBloc>().add(FilterName(name: text));
                    },
                    decoration: InputDecoration(
                      hintText: 'Filtrar nombre',
                      hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                      contentPadding: EdgeInsets.all(8),
                    ),
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color
                    ),
                  ),
                ),
              ),

              //Boton de limpiar
              ElevatedButton(
                onPressed: () {
                  context.read<PokemonBloc>().add(ClearFilter());
                },
                child: Text("Limpiar")
              ),
            ],
          ),
        ),
        
        // Boton con icono de estrella
        IconButton(
          onPressed: () {
            context.read<PokemonBloc>().add(ToggleFavoriteFilter());
          },
          icon: Icon(context.read<PokemonBloc>().favoriteFilter
              ? Icons.star
              : Icons.star_border),
            color: Colors.yellow,
            iconSize: 40,
        ),
      ],
    );
  }
  
}