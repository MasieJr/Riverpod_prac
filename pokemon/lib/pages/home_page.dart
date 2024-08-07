import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon/controllers/home_page_controller.dart';
import 'package:pokemon/models/page_data.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/providers/pokemon_data_providers.dart';
import 'package:pokemon/widgets/pokemon_card.dart';
import 'package:pokemon/widgets/pokemon_list_tile.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(
    HomePageData.initial(),
  );
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _allPokemonsListController = ScrollController();
  late HomePageController _homePageController;
  late HomePageData _homePageData;
  late List<String> _favouritePokemons;

  @override
  void initState() {
    super.initState();
    _allPokemonsListController.addListener(_scrollLister);
  }

  @override
  void dispose() {
    _allPokemonsListController.removeListener(_scrollLister);
    _allPokemonsListController.dispose();
    super.dispose();
  }

  void _scrollLister() {
    if (_allPokemonsListController.offset >=
            _allPokemonsListController.position.maxScrollExtent * 1 &&
        !_allPokemonsListController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(
      homePageControllerProvider.notifier,
    );
    _homePageData = ref.watch(
      homePageControllerProvider,
    );
    _favouritePokemons = ref.watch(
      favouritePokemonsProvider,
    );
    return Scaffold(
      body: _buildUI(
        context,
      ),
    );
  }

  Widget _buildUI(
    BuildContext context,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _favouritePokemonsList(
                context,
              ),
              _allPokemonsList(
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _favouritePokemonsList(
    BuildContext context,
  ) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Favourites",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.50,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_favouritePokemons.isNotEmpty)
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.48,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: _favouritePokemons.length,
                      itemBuilder: (context, index) {
                        String pokemanURL = _favouritePokemons[index];
                        return PokemonCard(
                          pokemanURL: pokemanURL,
                        );
                      },
                    ),
                  ),
                if (_favouritePokemons.isEmpty)
                  const Text(
                    "No favourite pokemon yet! :(",
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _allPokemonsList(
    BuildContext context,
  ) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "All Pokemons",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.60,
            child: ListView.builder(
                controller: _allPokemonsListController,
                itemCount: _homePageData.data?.results?.length ?? 0,
                itemBuilder: (context, index) {
                  PokemonListResult pokemon =
                      _homePageData.data!.results![index];
                  return PokemonListTile(pokemanURL: pokemon.url!);
                }),
          )
        ],
      ),
    );
  }
}
