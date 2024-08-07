import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemanURL;
  const PokemonListTile({super.key, required this.pokemanURL});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final pokemon = ref.watch(
      pokemonDataProvider(
        pokemanURL,
      ),
    );
    return pokemon.when(data: (data) {
      return _tile(
        context,
        false,
        data,
      );
    }, error: (error, stackTrace) {
      return Text(
        "error: $error",
      );
    }, loading: () {
      return _tile(
        context,
        true,
        null,
      );
    });
  }

  Widget _tile(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      enabled: true,
      child: ListTile(
        title: Text(
          pokemanURL,
        ),
      ),
    );
  }
}
