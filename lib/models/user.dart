// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  Usuario({
    this.name,
    this.email,
    this.password,
  });

  String? name;
  String? email;
  String? password;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        name: json["name"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
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
