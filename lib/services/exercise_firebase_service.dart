import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rehabilitacion_app/models/exercise.dart';

class ExerciseFirebaseService extends ChangeNotifier {
  final String _baseUrl = 'rehabilitacion-fisica-default-rtdb.firebaseio.com';
  final List<Exercise> exercises = [];
  late Exercise? selectedExercise;

  final storage = new FlutterSecureStorage();

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  ExerciseFirebaseService() {
    this.loadExercises();
  }

  Future loadExercises() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'ejercicio.json');
    final resp = await http.get(url);

    final Map<String, dynamic> exercisesMap = json.decode(resp.body);

    exercisesMap.forEach((key, value) {
      final tempExercise = Exercise.fromMap(value);
      tempExercise.id = key;
      this.exercises.add(tempExercise);
    });

    this.isLoading = false;
    notifyListeners();
  }

  Future saveOrCreateExercise(Exercise exercise) async {
    isSaving = true;
    notifyListeners();

    if (exercise.id == null) {
      // Crear
      await this.createExercise(exercise);
    } else {
      // Actualizar
      await this.updateExercise(exercise);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> createExercise(Exercise exercise) async {
    final url = Uri.https(_baseUrl, 'ejercicio.json');
    final resp = await http.post(url, body: exercise.toJson());
    final decodedData = json.decode(resp.body);

    exercise.id = decodedData['name'];
    this.exercises.add(exercise);

    return '';
  }

  Future<String> updateExercise(Exercise exercise) async {
    final url = Uri.https(_baseUrl, 'ejercicio/${exercise.id}.json');
    final resp = await http.put(url, body: exercise.toJson());
    final decodedData = json.decode(resp.body);

    final index =
        this.exercises.indexWhere((element) => element.id == exercise.id);

    this.exercises[index] = exercise;

    return exercise.id!;
  }

  void updateSelectedExerciseImage(String path) {
    this.selectedExercise!.video = path;
    this.newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
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
