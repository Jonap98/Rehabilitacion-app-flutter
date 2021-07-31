import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String pregunta;
  final String boton;
  final String ruta;

  const Labels({
    Key? key,
    required this.pregunta,
    required this.boton,
    required this.ruta,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            this.pregunta,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 15.0,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, ruta),
            child: Text(
              this.boton,
              style: TextStyle(
                color: Colors.blue[600],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
