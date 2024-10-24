import 'package:flutter/material.dart';
import '../models/noticia.dart';

class DetalleNoticia extends StatelessWidget {
  final Noticia noticia;

  DetalleNoticia({required this.noticia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(noticia.titulo),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (noticia.urlToImage.isNotEmpty)
              Image.network(noticia.urlToImage),
            SizedBox(height: 16.0),
            Text(
              noticia.titulo,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              noticia.descripcion,
              style: TextStyle(fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }
}
