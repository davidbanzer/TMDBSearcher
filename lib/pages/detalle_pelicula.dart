import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:themoviedb_flutter/main.dart';
import 'package:themoviedb_flutter/models/Pelicula.dart';
import 'package:http/http.dart' as http;
import 'package:themoviedb_flutter/models/detalle_pelicula.dart';

class DetallePelicula extends StatefulWidget {
  final num id;

  const DetallePelicula(this.id, {Key? key}) : super(key: key);

  @override
  State<DetallePelicula> createState() => _DetallePeliculaState();
}

class _DetallePeliculaState extends State<DetallePelicula> {
  Future<Detalle>? _detallePelicula;

  Future<Detalle> _obtenerPelicula(num id) async {
    final respuesta = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/${id.toString()}?api_key=c8c107f756a3c071378373802c283c03&language=en-US"));
    Detalle pelicula;
    if (respuesta.statusCode == 200) {
      String contenido = utf8.decode(respuesta.bodyBytes);
      final json = jsonDecode(contenido);
      String generos = "";
      for (var i = 0; i < json["genres"].length; i++) {
        generos = generos + json["genres"][i]["name"] + ", ";
      }
      generos = generos.substring(0, generos.length - 2);
      pelicula = Detalle(
          json["id"],
          json["original_title"],
          json["release_date"],
          json["overview"],
          json["poster_path"].toString() != "null"
              ? "https://image.tmdb.org/t/p/w500" + json["poster_path"]
              : "https://cdn-a.william-reed.com/var/wrbm_gb_food_pharma/storage/images/9/2/8/5/235829-6-eng-GB/Feed-Test-SIC-Feed-20142_news_large.jpg",
          json["vote_average"],
          generos,
          json["runtime"]);
      return pelicula;
    } else {
      throw Exception("Falló la conexion");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _detallePelicula = _obtenerPelicula(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
          appBar: AppBar(
              title: Text('Material App Bar'),
              leading:
                  BackButton(onPressed: () => Navigator.pop(context, false))),
          resizeToAvoidBottomInset: false,
          body: FutureBuilder(
            future: _detallePelicula,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Center(child: _crearCard(snapshot.data));
              } else if (snapshot.hasError) {
                print(snapshot.error);
              }
              return Center(child: CircularProgressIndicator());
            },
          )),
    );
  }

  Card _crearCard(data) {
    return Card(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(data.titulo + "( " + data.lanzamiento + ") "),
        ),
        Text("Géneros: " + data.genero),
        CachedNetworkImage(
          imageUrl: data.imagen,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          height: 350,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(data.sinopsis),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Calificación: " + data.calificacion.toString()),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Duración: " + data.duracion.toString() + " minutos"),
        )
      ]),
    );
  }
}
