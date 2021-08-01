// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

User usuarioFromJson(String str) => User.fromJson(json.decode(str));

String usuarioToJson(User data) => json.encode(data.toJson());

class User {
  late final String id;
  final String nombre;
  final String apellido;
  final String email;

  User({
    this.id = '',
    this.nombre = '',
    this.apellido = '',
    this.email = '',
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        nombre: json["nombre"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "email": email,
      };
}



// class Usuario {
//   String? nombre;
//   String? email;
//   String? uid;

//   Usuario({
//     this.nombre,
//     this.email,
//     this.uid,
//   });
// }
