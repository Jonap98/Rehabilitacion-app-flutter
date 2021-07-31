import 'package:flutter/material.dart';
import 'package:rehabilitacion_app/models/exercise.dart';

class ExerciseFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Exercise exercise;

  ExerciseFormProvider(this.exercise);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
