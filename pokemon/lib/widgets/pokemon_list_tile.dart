import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/providers/pokemon_data_providers.dart';
import 'package:pokemon/widgets/pokemon_stats_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemanURL;
  late FavouritePokemonsProvider _favouritePokemonsProvider;
  late List<String> _favouritePokemons;
  PokemonListTile({super.key, required this.pokemanURL});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    _favouritePokemonsProvider = ref.watch(
      favouritePokemonsProvider.notifier,
    );
    _favouritePokemons = ref.watch(
      favouritePokemonsProvider,
    );
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
      enabled: isLoading,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
              context: context,
              builder: (_) {
                return PokemonStatsCard(
                  pokemanURL: pokemanURL,
                );
              },
            );
          }
        },
        child: ListTile(
          leading: pokemon != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(
                    pokemon.sprites!.frontDefault!,
                  ),
                )
              : CircleAvatar(),
          title: Text(
            pokemon != null
                ? pokemon.name!.toUpperCase()
                : "Failed to load pokemons, Please wait",
          ),
          subtitle: Text(
            "Has ${pokemon?.moves?.length.toString() ?? 0} moves",
          ),
          trailing: IconButton(
            onPressed: () {
              if (_favouritePokemons.contains(pokemanURL)) {
                _favouritePokemonsProvider.removeFavouritePokemon(
                  pokemanURL,
                );
              } else {
                _favouritePokemonsProvider.addFavouritePokemon(
                  pokemanURL,
                );
              }
            },
            icon: Icon(
              _favouritePokemons.contains(pokemanURL)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
