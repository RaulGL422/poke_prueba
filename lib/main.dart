import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_prueba/bloc.dart';
import 'package:poke_prueba/pages/home.dart';
import 'package:poke_prueba/theme/theme.dart';
import 'package:poke_prueba/events.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poke Prueba',
      theme: AppTheme.getTheme(context),
      home: BlocProvider(
        create: (context) => PokemonBloc()..add(LoadPokemons()),
        child: HomePage(),
      ),
    );
  }
}