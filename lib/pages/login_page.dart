import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehabilitacion_app/helpers/mostrar_alerta.dart';
import 'package:rehabilitacion_app/services/auth_form_validator.dart';

import 'package:rehabilitacion_app/services/firebase_auth_service.dart';
import 'package:rehabilitacion_app/services/services.dart';
import 'package:rehabilitacion_app/services/therapy_firebase_service.dart';
import 'package:rehabilitacion_app/services/therapy_form_provider.dart';
import 'package:rehabilitacion_app/widgets/boton_azul.dart';
import 'package:rehabilitacion_app/widgets/custom_input.dart';
import 'package:rehabilitacion_app/widgets/labels.dart';

class LoginPage extends StatelessWidget {
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
                SizedBox(height: 20.0),
                _Form(),
                Labels(
                    pregunta: '¿Aún no tienes cuenta?',
                    boton: 'Registrate',
                    ruta: 'register_page'),
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
    final therapyService = Provider.of<TherapyFirebaseService>(context);
    final formService = Provider.of<FormValidator>(context);

    // final usuarioCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final regexp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    return Container(
      // margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Form(
        key: formService.loginKey,
        child: Column(
          children: <Widget>[
            Container(
              height: 200.0,
              width: 200.0,
              margin: EdgeInsets.only(bottom: 20.0),
              child: Image(
                image: AssetImage('assets/RLogoColor.png'),
              ),
            ),
            // CustomInput(
            //   icon: Icons.mail_outline,
            //   placeholder: 'Email',
            //   keyboardType: TextInputType.emailAddress,
            //   textController: emailCtrl,
            // ),
            // CustomInput(
            //   icon: Icons.lock_open,
            //   placeholder: 'Password',
            //   textController: passCtrl,
            // ),
            TextFormField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'El email es obligatorio';
                } else if (!regexp.hasMatch(value)) {
                  return 'Correo electrónico inválido';
                }
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: passCtrl,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'La contraseña es obligatoria';
                } else if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
              },
            ),
            SizedBox(height: 30.0),
            BotonAzul(
              text: 'Ingresar',
              onPressed: firebaseAuthService.autenticando
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();

                      if (!formService.isValidLogin()) return;

                      // final String? errorMessage = await firebaseAuthService
                      //     .login(emailCtrl.text.trim(), passCtrl.text.trim());

                      // if (errorMessage == null) {
                      //   // therapyService.sessionExpired = false;
                      //   // therapyService.isLoading = true;
                      //   Navigator.pushReplacementNamed(context, 'therapies_page');
                      // } else {
                      final loginOk = await firebaseAuthService.login(
                        emailCtrl.text.trim(),
                        passCtrl.text.trim(),
                      );
                      if (loginOk) {
                        Navigator.pushReplacementNamed(
                            context, 'therapies_page');
                        // addThisUser(
                        //     emailCtrl.text.trim(), passCtrl.text.trim());
                      } else {
                        // print(errorMessage);
                        // NotificationsService.showSnackbar('errorMessage');
                        mostrarAlerta(
                          context,
                          'Login incorrecto',
                          'Revisar sus credenciales nuevamente.',
                        );
                      }

                      // if (loginOk) {
                      //   Navigator.pushReplacementNamed(context, 'home_page');
                      // } else {
                      //   mostrarAlerta(
                      //     context,
                      //     'Login incorrecto',
                      //     'Revisar sus credenciales nuevamente',
                      //   );
                      // }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
