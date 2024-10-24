class Noticia {
  final String titulo;
  final String descripcion;
  final String url;
  final String urlToImage;

  Noticia({
    required this.titulo,
    required this.descripcion,
    required this.url,
    required this.urlToImage,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      titulo: json['title'] ?? 'Título no disponible',
      descripcion: json['description'] ?? 'Descripción no disponible',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': titulo,
      'description': descripcion,
      'url': url,
      'urlToImage': urlToImage,
    };
  }
}
