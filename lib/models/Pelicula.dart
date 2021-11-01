class Pelicula {
  num? id;
  String? titulo;
  String? lanzamiento;
  String? sinopsis;
  String? imagen;
  num? calificacion;

  Pelicula(id, titulo, lanzamiento, sinopsis, imagen, calificacion) {
    this.id = id;
    this.titulo = titulo;
    this.lanzamiento = lanzamiento;
    this.sinopsis = sinopsis;
    this.imagen = imagen;
    this.calificacion = calificacion;
  }
}
