// lib/screens/noticias_search_delegate.dart
import 'package:flutter/material.dart';
import '../models/noticia.dart';
import '../services/NewsService.dart';
import 'detalle_noticia.dart';

class NoticiasSearchDelegate extends SearchDelegate {
  final NewsService _newsService = NewsService();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Noticia>>(
      future: _newsService.searchNews(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar noticias'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No se encontraron resultados'));
        } else {
          final noticias = snapshot.data!;
          return ListView.builder(
            itemCount: noticias.length,
            itemBuilder: (context, index) {
              final noticia = noticias[index];
              return ListTile(
                leading: (noticia.urlToImage.isNotEmpty)
                    ? Image.network(
                        noticia.urlToImage,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : Container(width: 100, color: Colors.grey),
                title: Text(noticia.titulo),
                subtitle: Text(noticia.descripcion),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalleNoticia(noticia: noticia),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
