import 'package:flutter/material.dart';

class DetallePelicula extends StatefulWidget {
  final num id;
  const DetallePelicula(this.id, {Key? key}) : super(key: key);

  @override
  State<DetallePelicula> createState() => _DetallePeliculaState();
}

class _DetallePeliculaState extends State<DetallePelicula> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text(widget.id.toString()),
          ),
        ),
      ),
    );
  }
}
