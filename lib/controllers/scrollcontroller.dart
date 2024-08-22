import 'package:flutter/material.dart';

class PokemonScrollController extends ScrollController {
  final VoidCallback onEndReached;

  PokemonScrollController({required this.onEndReached}) {
    addListener(onScroll);
  }

  void onScroll() {
    final maxScroll = position.maxScrollExtent;
    final currentScroll = position.pixels;

    if (currentScroll >= maxScroll) {
      onEndReached();
    }
  }
}
