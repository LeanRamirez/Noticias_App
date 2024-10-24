import 'package:flutter/material.dart';
import '../models/noticia.dart';
import '../services/NewsService.dart';
import 'detalle_noticia.dart';
import 'noticias_search_delegate.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NoticiasPage extends StatefulWidget {
  @override
  _NoticiasPageState createState() => _NoticiasPageState();
}

final List<String> categories = [
  'general',
  'business',
  'entertainment',
  'health',
  'science',
  'sports',
  'technology',
];

class _NoticiasPageState extends State<NoticiasPage>
    with SingleTickerProviderStateMixin {
  final NewsService _newsServices = NewsService();
  late Future<List<Noticia>> _futureNoticias;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _futureNoticias = _newsServices.fetchNews();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      String selectedCategory = categories[_tabController.index];
      setState(() {
        _futureNoticias = _newsServices.fetchNews(category: selectedCategory);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Últimas Noticias'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: categories.map((category) {
            return Tab(text: category.toUpperCase());
          }).toList(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: NoticiasSearchDelegate());
            },
          ),
        ],
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
                  leading: CachedNetworkImage(
                    imageUrl: noticia.imagenUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    noticia.titulo,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    noticia.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
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
      ),
    );
  }
}
