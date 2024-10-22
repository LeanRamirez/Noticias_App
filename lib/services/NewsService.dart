import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/noticia.dart';

class NewsServices {
  final String apiKey = '46958fa538584338afa50ac2b02a7b48';

  Future<List<Noticia>> fetchNews() async {
    final url =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['articles'];
      return data.map((json) => Noticia.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las noticias');
    }
  }
}
