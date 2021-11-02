class Detalle {
  num? id;
  String? titulo;
  String? lanzamiento;
  String? sinopsis;
  String? imagen;
  num? calificacion;
  String? genero;
  int? duracion;

  Detalle(id, titulo, lanzamiento, sinopsis, imagen, calificacion, genero,
      duracion) {
    this.id = id;
    this.titulo = titulo;
    this.lanzamiento = lanzamiento;
    this.sinopsis = sinopsis;
    this.imagen = imagen;
    this.calificacion = calificacion;
    this.genero = genero;
    this.duracion = duracion;
  }
}
