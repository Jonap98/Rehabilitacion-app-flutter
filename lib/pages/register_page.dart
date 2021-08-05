import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehabilitacion_app/helpers/mostrar_alerta.dart';
import 'package:rehabilitacion_app/services/auth_form_validator.dart';

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
                SizedBox(height: 20.0),
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
    final formService = Provider.of<FormValidator>(context);

    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final regexp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    return Container(
      // margin: EdgeInsets.only(top: 40.0),
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Form(
        key: formService.registerKey,
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
              text: 'Crear cuenta',
              onPressed: firebaseAuthService.autenticando
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();

                      if (!formService.isValidRegister()) return;

                      final loginOk = await firebaseAuthService.createUser(
                        emailCtrl.text.trim(),
                        passCtrl.text.trim(),
                      );
                      if (loginOk) {
                        Navigator.pushReplacementNamed(
                            context, 'therapies_page');
                      } else {
                        mostrarAlerta(
                          context,
                          'Registro incorrecto',
                          'El email ingresado ya pertenece a otra cuenta.',
                        );
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
