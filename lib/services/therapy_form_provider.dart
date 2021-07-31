import 'package:flutter/material.dart';
import 'package:rehabilitacion_app/models/therapy.dart';

class TherapyFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Therapy therapy;

  TherapyFormProvider(this.therapy);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
