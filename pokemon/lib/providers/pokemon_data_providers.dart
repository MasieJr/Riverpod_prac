import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/services/database_service.dart';
import 'package:pokemon/services/http_service.dart';

final pokemonDataProvider =
    FutureProvider.family<Pokemon?, String>((ref, url) async {
  HttpService _httpService = GetIt.instance.get<HttpService>();
  Response? res = await _httpService.get(
    url,
  );
  if (res != null && res.data != null) {
    return Pokemon.fromJson(res.data);
  }
  return null;
});

final favouritePokemonsProvider =
    StateNotifierProvider<FavouritePokemonsProvider, List<String>>((ref) {
  return FavouritePokemonsProvider(
    [],
  );
});

class FavouritePokemonsProvider extends StateNotifier<List<String>> {
  final DatabaseService _databaseService =
      GetIt.instance.get<DatabaseService>();

  String FAVOURITE_POKEMON_LIST_KEY = "FAVOURITE_POKEMON_LIST_KEY";

  FavouritePokemonsProvider(super._state) {
    _setup();
  }
  Future<void> _setup() async {
    List<String>? results = await _databaseService.getList(
      FAVOURITE_POKEMON_LIST_KEY,
    );
    state = results ?? [];
  }

  void addFavouritePokemon(String url) {
    state = [...state, url];
    _databaseService.saveList(FAVOURITE_POKEMON_LIST_KEY, state);
  }

  void removeFavouritePokemon(String url) {
    state = state.where((e) => e != url).toList();
    _databaseService.saveList(FAVOURITE_POKEMON_LIST_KEY, state);
  }
}
