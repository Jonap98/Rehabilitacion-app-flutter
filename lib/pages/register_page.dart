import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rehabilitacion_app/services/firebase_auth_service.dart';
import 'package:rehabilitacion_app/services/services.dart';
import 'package:rehabilitacion_app/widgets/boton_azul.dart';
import 'package:rehabilitacion_app/widgets/custom_input.dart';
import 'package:rehabilitacion_app/widgets/labels.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Logo(titulo: 'Registro'),
                SizedBox(height: 100.0),
                _Form(),
                Labels(
                    pregunta: '¿Ya tienes una cuenta?',
                    boton: 'Inicia sesión',
                    ruta: 'login_page'),
                Text(
                  'Términos y condiciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w200),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    final firebaseAuthService = Provider.of<FirebaseAuthService>(context);

    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Container(
      margin: EdgeInsets.only(top: 40.0),
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_open,
            placeholder: 'Password',
            textController: passCtrl,
          ),
          BotonAzul(
            text: 'Crear cuenta',
            onPressed: firebaseAuthService.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    final String? errorMessage =
                        await firebaseAuthService.createUser(
                            emailCtrl.text.trim(), passCtrl.text.trim());

                    if (errorMessage == null) {
                      Navigator.pushReplacementNamed(context, 'therapies_page');
                    } else {
                      print(errorMessage);
                      NotificationsService.showSnackbar(errorMessage);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
