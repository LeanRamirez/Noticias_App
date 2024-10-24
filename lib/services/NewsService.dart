import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/noticia.dart';

class NewsService {
  final String _apiKey =
      'f4018716817d4b8792602e4c0d55c4eb'; // Reemplaza con tu API Key
  final String _baseUrl = 'https://newsapi.org/v2/top-headlines';

  Future<List<Noticia>> fetchNews({String? category}) async {
    String url = '$_baseUrl?language=en&apiKey=$_apiKey'; // URL base

    // Si se proporciona una categoría, la añadimos a la URL
    if (category != null) {
      url += '&category=$category';
    }

    // Imprime la URL que se está utilizando para la solicitud
    print('Fetching news from URL: $url');

    try {
      // Realiza la solicitud HTTP
      final response = await http.get(Uri.parse(url));
      // Imprime el código de estado y el cuerpo de la respuesta
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Verifica si la respuesta es exitosa
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> articles = data['articles'];
        print(
            'Articles fetched: ${articles.length}'); // Imprime la cantidad de artículos encontrados

        return articles.map((json) => Noticia.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar noticias: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e'); // Imprime el error si ocurre
      throw Exception('Error al cargar noticias');
    }
  }

  Future<List<Noticia>> searchNews(String query) async {
    final url = '$_baseUrl?q=$query&language=es&apiKey=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> articles = data['articles'];

        return articles.map((json) => Noticia.fromJson(json)).toList();
      } else {
        throw Exception('Error al buscar noticias');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error al buscar noticias');
    }
  }
}
