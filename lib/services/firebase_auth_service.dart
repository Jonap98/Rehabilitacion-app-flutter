import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class FirebaseAuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyCJKd2wJVyXZrSMvdS91nNZtlKUVI5DZVI';

  final storage = new FlutterSecureStorage();

  bool _autenticando = false;

  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  // Si retornamos algo, hay un error, si no, todo bien
  Future<String?> createUser(String email, String password) async {
    this.autenticando = true;

    // Crear información del post
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    // Crear el URL, en postman es:
    // https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCJKd2wJVyXZrSMvdS91nNZtlKUVI5DZVI
    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});

    // Disparamos la petición http
    final resp = await http.post(url, body: json.encode(authData));

    // Decodificamos la respuesta
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    this.autenticando = false;

    // Analizamos la respuesta para ver el id Token o procesar el error
    // print(decodedResp);
    if (decodedResp.containsKey('idToken')) {
      storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    this.autenticando = true;

    // Crear información del post
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    // Crear el URL, en postman es:
    // https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCJKd2wJVyXZrSMvdS91nNZtlKUVI5DZVI
    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});

    // Disparamos la petición http
    final resp = await http.post(url, body: json.encode(authData));

    // Decodificamos la respuesta
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    this.autenticando = false;
    notifyListeners();

    // Analizamos la respuesta para ver el id Token o procesar el error
    // print('Analisis de la respuesta del login: $decodedResp');
    if (decodedResp.containsKey('idToken')) {
      storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
  }

  Future<String> isLoggedIn() async {
    String? token = await storage.read(key: 'token');
    print('Token: $token');

    return await storage.read(key: 'token') ?? '';
  }
}
