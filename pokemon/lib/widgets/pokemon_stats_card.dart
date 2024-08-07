import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon/providers/pokemon_data_providers.dart';

class PokemonStatsCard extends ConsumerWidget {
  final String pokemanURL;

  const PokemonStatsCard({
    super.key,
    required this.pokemanURL,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(
      pokemonDataProvider(
        pokemanURL,
      ),
    );

    return AlertDialog(
      title: const Text(
        "Statistics",
      ),
      content: pokemon.when(
        data: (data) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: data?.stats?.map((s) {
                  return Text(
                    "${s.stat?.name?.toUpperCase()}: ${s.baseStat}",
                  );
                }).toList() ??
                [],
          );
        },
        error: (error, stackTrace) {
          return Text(
            "Error: $error",
          );
        },
        loading: () {
          return const CircularProgressIndicator(
            color: Colors.white,
          );
        },
      ),
    );
  }
}
