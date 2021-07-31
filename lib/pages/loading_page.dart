import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rehabilitacion_app/services/firebase_auth_service.dart';
import 'package:rehabilitacion_app/pages/login_page.dart';
import 'package:rehabilitacion_app/pages/therapies_page.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Aqui no se necesita redibujar nada, por eso lo ponemos en false a pesar de estar en el build
    final firebaseAuthService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    // final therapyService = Provider.of<TherapyFirebaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cargando, porfavor espere'),
      ),
      body: Center(
        child: FutureBuilder(
          future: firebaseAuthService.isLoggedIn(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) {
              print('!snapshot.hasData:  ${snapshot.hasData}');
              return CircularProgressIndicator(color: Color(0xff5ec1c8));
            }
            // Microtask se ejecuta tan pronto la construccion del builder se termina
            if (snapshot.data == '') {
              Future.microtask(
                () {
                  // Transición manual para evitar que se vea el cambio de pantalla en
                  // algunos dispositivos
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => LoginPage(),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                  // Navigator.of(context).pushReplacementNamed('therapies_page');
                },
              );
            } else {
              Future.microtask(
                () {
                  print('snapshot.data: ${snapshot.data}');
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => TherapiesPage(),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                },
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
