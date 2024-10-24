class Noticia {
  final String titulo;
  final String descripcion;
  final String imagenUrl;

  Noticia({
    required this.titulo,
    required this.descripcion,
    required this.imagenUrl,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      titulo: json['title'] ?? 'Sin título',
      descripcion: json['description'] ?? 'Sin descripción',
      imagenUrl: json['urlToImage'] ?? '',
    );
  }
}
