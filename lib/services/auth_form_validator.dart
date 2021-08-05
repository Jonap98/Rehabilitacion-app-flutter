import 'package:flutter/material.dart';

class FormValidator extends ChangeNotifier {
  GlobalKey<FormState> loginKey = new GlobalKey<FormState>();
  GlobalKey<FormState> registerKey = new GlobalKey<FormState>();

  bool isValidLogin() {
    return loginKey.currentState?.validate() ?? false;
  }

  bool isValidRegister() {
    return registerKey.currentState?.validate() ?? false;
  }
}
