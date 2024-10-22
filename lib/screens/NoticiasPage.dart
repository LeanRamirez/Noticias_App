import 'package:flutter/material.dart';
import '../models/noticia.dart';
import '../services/NewsService.dart';
import 'detalle_noticia.dart';

class NoticiasPage extends StatefulWidget {
  @override
  _NoticiasPageState createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  final NewsServices _newsServices = NewsServices();
  late Future<List<Noticia>> _futureNoticias;

  @override
  void initState() {
    super.initState();
    _futureNoticias = _newsServices.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ultimas noticias'),
      ),
      body: FutureBuilder<List<Noticia>>(
        future: _futureNoticias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar noticias'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay noticias disponibles'));
          } else {
            final noticias = snapshot.data!;
            return ListView.builder(
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                final noticia = noticias[index];
                return ListTile(
                  leading: (noticia.imagenURL.isNotEmpty)
                      ? Image.network(
                          noticia.imagenURL,
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
                          builder: (context) =>
                              DetalleNoticia(noticia: noticia),
                        ));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
