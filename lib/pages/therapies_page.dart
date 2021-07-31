import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:rehabilitacion_app/models/therapy.dart';
import 'package:rehabilitacion_app/services/firebase_auth_service.dart';
import 'package:rehabilitacion_app/services/therapy_firebase_service.dart';
import 'package:rehabilitacion_app/widgets/therapy_card.dart';
import 'package:rehabilitacion_app/pages/pages.dart';

class TherapiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final therapyService = Provider.of<TherapyFirebaseService>(context);
    final firebaseAuthService = Provider.of<FirebaseAuthService>(context);

    if (therapyService.isLoading) return LoadingProductsPage();
    return Scaffold(
      appBar: AppBar(
        title: Text('Terapias'),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.signOutAlt),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login_page');
              firebaseAuthService.logout();
            },
          ),
        ],
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: therapyService.therapies.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          // TODO: Tap sostenido para eliminar
          onTap: () => Navigator.pushNamed(context, 'exercises_page',
              arguments: therapyService.therapies[index].id),

          onDoubleTap: () {
            therapyService.selectedTherapy =
                therapyService.therapies[index].copy();
            Navigator.pushNamed(
              context,
              'creating_therapy',
            );
          },
          child: TherapyCard(
            therapy: therapyService.therapies[index],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          therapyService.selectedTherapy = new Therapy(
            nombre: '',
          );
          Navigator.pushNamed(context, 'creating_therapy');
        },
      ),
    );
  }
}
