// To parse this JSON data, do
//
//     final therapy = therapyFromMap(jsonString);

import 'dart:convert';

class Therapy {
  Therapy({
    this.id,
    this.imagen,
    required this.nombre,
  });

  String? id;
  String? imagen;
  String nombre;

  factory Therapy.fromJson(String str) => Therapy.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Therapy.fromMap(Map<String, dynamic> json) => Therapy(
        imagen: json["imagen"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toMap() => {
        "imagen": imagen,
        "nombre": nombre,
      };

  Therapy copy() => Therapy(
        nombre: this.nombre,
        imagen: this.imagen,
        id: this.id,
      );
}
