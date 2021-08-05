import 'dart:io';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:rehabilitacion_app/models/therapy.dart';

class TherapyRealTimeService extends ChangeNotifier {
  final String _baseUrl = 'rehabilitacion-fisica-default-rtdb.firebaseio.com';

  final List<Therapy> therapies = [];
  late Therapy? selectedTherapy;

  final storage = new FlutterSecureStorage();

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  TherapyRealTimeService() {
    this.loadTherapies();
  }

  Future loadTherapies() async {
    this.isLoading = true;
    notifyListeners();

    // TODO: Implementación de retorno a login con sesión expirada y error con
    // login correcto la primera vez
    // String? token = '';
    // token = await storage.read(key: 'token');
    // print('Token: $token');

    // if (token == null) {
    //   print('Token vacio, sesion expirada');

    //   this.isLoading = false;
    //   // this.sessionExpired = true;
    //   notifyListeners();

    //   return;
    // }

    final url = Uri.https(_baseUrl, 'terapias.json',
        {'auth': await storage.read(key: 'token') ?? ''});

    final resp = await http.get(url);

    final Map<String, dynamic> therapiesMap = json.decode(resp.body);

    therapiesMap.forEach((key, value) {
      final tempTherapy = Therapy.fromMap(value);
      tempTherapy.id = key;
      this.therapies.add(tempTherapy);
    });

    this.isLoading = false;
    notifyListeners();
  }

  Future saveOrCreateTherapy(Therapy therapy) async {
    isSaving = true;
    notifyListeners();

    if (therapy.id == null) {
      // Crear
      // await this.createTherapy(therapy);
      await this.addTherapy(therapy);
    } else {
      // Actualizar
      await this.updateTherap(therapy);
      // await this.updateTherapy(therapy);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> createTherapy(Therapy therapy) async {
    final url = Uri.https(_baseUrl, 'terapias.json');
    final resp = await http.post(url, body: therapy.toJson());
    final decodedData = json.decode(resp.body);

    // print(decodedData); en este print se observa 'name' como el id de firebase
    therapy.id = decodedData['name'];
    this.therapies.add(therapy);

    return '';
  }

  Future<void> addTherapy(Therapy therapy) async {
    CollectionReference collectionTherapy =
        FirebaseFirestore.instance.collection('therapies');

    return collectionTherapy
        .add({
          'name': therapy.nombre,
          'image': therapy.imagen,
        })
        .then((value) => print('Terapia registrada'))
        .catchError((error) => print('Error $error'));
  }

  void updateSelectedTherapyImage(String path) {
    this.selectedTherapy!.imagen = path;
    this.newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String> updateTherapy(Therapy therapy) async {
    final url = Uri.https(_baseUrl, 'terapias/${therapy.id}.json');
    final resp = await http.put(url, body: therapy.toJson());
    final decodedData = json.decode(resp.body);

    final index =
        this.therapies.indexWhere((element) => element.id == therapy.id);

    this.therapies[index] = therapy;
    // updateTherap(therapy.id!, therapy.nombre, therapy.imagen);

    return therapy.id!;
  }

  Future<void> updateTherap(Therapy therapy) async {
    CollectionReference collectionTherapy =
        FirebaseFirestore.instance.collection('therapies');

    // final index =
    //     this.therapies.indexWhere((element) => element.id == therapy.id);

    return collectionTherapy
        .doc(therapy.id)
        .set({
          'name': therapy.nombre,
          'image': therapy.imagen,
        })
        .then((value) => print('Terapia actualizada'))
        .catchError((error) => print('Error $error'));
  }

  Future<String?> uploadImage() async {
    if (this.newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    // https://api.cloudinary.com/v1_1/<cloud name>/<resource_type>/upload
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dlbgjolbl/image/upload?upload_preset=exhitflm');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salió mal');
      print(resp.body);
      return null;
    }

    // Indicando que se subió la imagen, limpiando esa propiedad
    this.newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
