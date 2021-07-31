// To parse this JSON data, do
//
//     final exercise = exerciseFromMap(jsonString);

import 'dart:convert';

class Exercise {
  Exercise({
    this.id,
    required this.idTerapia,
    required this.nombre,
    this.video,
  });

  String? id;
  String idTerapia;
  String nombre;
  String? video;

  factory Exercise.fromJson(String str) => Exercise.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Exercise.fromMap(Map<String, dynamic> json) => Exercise(
        // id: json["id"],
        idTerapia: json["id_terapia"],
        nombre: json["nombre"],
        video: json["video"],
      );

  Map<String, dynamic> toMap() => {
        // "id": id,
        "id_terapia": idTerapia,
        "nombre": nombre,
        "video": video,
      };

  Exercise copy() => Exercise(
        id: this.id,
        idTerapia: this.idTerapia,
        nombre: this.nombre,
        video: this.video,
      );
}
