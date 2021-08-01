import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rehabilitacion_app/routes/routes.dart';
import 'package:rehabilitacion_app/services/exercise_firebase_service.dart';
import 'package:rehabilitacion_app/services/firebase_auth_service.dart';
import 'package:rehabilitacion_app/services/services.dart';
import 'package:rehabilitacion_app/services/therapy_firebase_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _init = Firebase.initializeApp();

    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget();
        } else if (snapshot.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => FirebaseAuthService(),
              ),
              ChangeNotifierProvider(
                create: (_) => TherapyFirebaseService(),
              ),
              ChangeNotifierProvider(
                create: (_) => ExerciseFirebaseService(),
                // create: (_) => ExerciseService(),
              ),
            ],
            child: MaterialApp(
              scaffoldMessengerKey: NotificationsService.messengerKey,
              debugShowCheckedModeBanner: false,
              title: 'Rehabilitación App',
              initialRoute: 'loading_page',
              routes: getApplicationRoutes(),
              theme: ThemeData.light().copyWith(
                appBarTheme: AppBarTheme(
                  elevation: 0.0,
                  color: Color(0xff5ec1c8),
                  centerTitle: true,
                ),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Color(0xff1bc4bc),
                  elevation: 0.0,
                ),
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}

class ErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Icon(Icons.error),
            Text('Algo salió mal'),
          ],
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularProgressIndicator(),
    );
  }
}
