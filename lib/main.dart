import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:themoviedb_flutter/models/Pelicula.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<Pelicula>>? _listaPeliculas;

  Future<List<Pelicula>> _obtenerPeliculas(String busqueda) async {
    final respuesta = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/search/movie?api_key=c8c107f756a3c071378373802c283c03&language=en-US&query=${busqueda}"));

    List<Pelicula> peliculas = [];

    if (respuesta.statusCode == 200) {
      String contenido = utf8.decode(respuesta.bodyBytes);
      final json = jsonDecode(contenido);
      for (var item in json["results"]) {
        peliculas.add(Pelicula(
            item["original_title"],
            item["release_date"],
            item["overview"],
            item["poster_path"].toString() != "null"
                ? "https://image.tmdb.org/t/p/w500" + item["poster_path"]
                : "https://cdn-a.william-reed.com/var/wrbm_gb_food_pharma/storage/images/9/2/8/5/235829-6-eng-GB/Feed-Test-SIC-Feed-20142_news_large.jpg",
            item["vote_average"]));
      }
      return peliculas;
    } else {
      throw Exception("Falló la conexion");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listaPeliculas = _obtenerPeliculas("iron");
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _busquedaController = TextEditingController(text: "");
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('TMDB Searcher'),
        ),
        body: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _busquedaController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.grey[300],
                        filled: true),
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _listaPeliculas = _obtenerPeliculas(
                              _busquedaController.text.toString());
                        });
                      },
                      child: Text("Buscar")),
                )
              ],
            ),
            FutureBuilder(
              future: _listaPeliculas,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: _listViewPeliculas(snapshot.data),
                    ),
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _listViewPeliculas(data) {
    List<Widget> peliculas = [];
    for (var pelicula in data) {
      peliculas.add(InkWell(
        onTap: () {
          print(pelicula.titulo);
        },
        child: Card(
            child: Column(
          children: [
            Expanded(
                child: CachedNetworkImage(
                    imageUrl: pelicula.imagen,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(pelicula.titulo),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(pelicula.lanzamiento),
            )
          ],
        )),
      ));
    }
    return peliculas;
  }
}
