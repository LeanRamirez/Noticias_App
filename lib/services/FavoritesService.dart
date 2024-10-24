import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/noticia.dart';

class FavoritesService {
  final String _favoritesKey = 'favoritos';

  // Obtener la lista de noticias favoritas
  Future<List<Noticia>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesStringList = prefs.getStringList(_favoritesKey) ?? [];

    return favoritesStringList
        .map((noticiaString) => Noticia.fromJson(jsonDecode(noticiaString)))
        .toList();
  }

  // Añadir una noticia a favoritos
  Future<void> addFavorite(Noticia noticia) async {
    final prefs = await SharedPreferences.getInstance();
    final currentFavorites = prefs.getStringList(_favoritesKey) ?? [];

    currentFavorites.add(jsonEncode(noticia.toJson()));

    await prefs.setStringList(_favoritesKey, currentFavorites);
  }

  // Eliminar una noticia de favoritos
  Future<void> removeFavorite(Noticia noticia) async {
    final prefs = await SharedPreferences.getInstance();
    final currentFavorites = prefs.getStringList(_favoritesKey) ?? [];

    // Convertimos de nuevo el JSON string a Noticia para comparar títulos
    currentFavorites.removeWhere(
        (n) => Noticia.fromJson(jsonDecode(n)).titulo == noticia.titulo);

    await prefs.setStringList(_favoritesKey, currentFavorites);
  }
}
