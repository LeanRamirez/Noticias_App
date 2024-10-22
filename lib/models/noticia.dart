class Noticia {
  final String titulo;
  final String descripcion;
  final String imagenURL;

  Noticia(
      {required this.titulo,
      required this.descripcion,
      required this.imagenURL});

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
        titulo: json['title'] ?? 'Sin titulo',
        descripcion: json['description'] ?? 'No hay descripción disponible',
        imagenURL: json['urlToImage'] ?? '');
  }
}
