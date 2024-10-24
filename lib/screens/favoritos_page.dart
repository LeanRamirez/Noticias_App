import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/noticia.dart';
import '../services/FavoritesService.dart';

class FavoritosPage extends StatefulWidget {
  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  final FavoritesService _favoritesService = FavoritesService();
  late Future<List<Noticia>> _futureFavorites;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _futureFavorites = _favoritesService.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias favoritas'),
      ),
      body: FutureBuilder<List<Noticia>>(
        future: _futureFavorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error al cargar noticias favoritas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tienes noticias favoritas'));
          } else {
            final noticias = snapshot.data!;
            return ListView.builder(
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                final noticia = noticias[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: noticia.imagenUrl ?? '',
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  title: Text(noticia.titulo),
                  subtitle: Text(noticia.descripcion),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _favoritesService.removeFavorite(noticia);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Noticia eliminada de favoritos'),
                      ));
                      _loadFavorites(); // Recargar los favoritos
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
