import 'package:flutter/material.dart';
import '../models/noticia.dart';
import '../services/NewsService.dart';
import 'detalle_noticia.dart';
import 'noticias_search_delegate.dart';

class NoticiasPage extends StatefulWidget {
  @override
  _NoticiasPageState createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage>
    with SingleTickerProviderStateMixin {
  final NewsService _newsService = NewsService();
  late Future<List<Noticia>> _futureNoticias;
  late TabController _tabController;

  final List<String> category = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: category.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _futureNoticias = _newsService.fetchNews(category: category[0]);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      String selectedCategory = category[_tabController.index];
      setState(() {
        _futureNoticias = _newsService.fetchNews(category: selectedCategory);
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
          tabs: category.map((category) {
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
            print(snapshot.hasData);
            print(snapshot.data);
            return Center(child: Text('No hay noticias disponibles'));
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
