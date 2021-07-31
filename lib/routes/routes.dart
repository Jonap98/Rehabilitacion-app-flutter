import 'package:flutter/material.dart';

import 'package:rehabilitacion_app/pages/creating_exercise.dart';
import 'package:rehabilitacion_app/pages/creating_therapy.dart';
import 'package:rehabilitacion_app/pages/exercises_page.dart';
import 'package:rehabilitacion_app/pages/loading_page.dart';
import 'package:rehabilitacion_app/pages/loading_products_page.dart';
import 'package:rehabilitacion_app/pages/login_page.dart';
import 'package:rehabilitacion_app/pages/register_page.dart';
import 'package:rehabilitacion_app/pages/therapies_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    'register_page': (BuildContext context) => RegisterPage(),
    'login_page': (BuildContext context) => LoginPage(),
    'loading_products': (BuildContext contxt) => LoadingProductsPage(),
    'loading_page': (BuildContext context) => LoadingPage(),
    'therapies_page': (BuildContext context) => TherapiesPage(),
    'exercises_page': (BuildContext context) => ExercisesPage(),
    'creating_therapy': (BuildContext context) => CreatingTherapy(),
    'creating_exercise': (BuildContext context) => CreatingExercise(),
  };
}
