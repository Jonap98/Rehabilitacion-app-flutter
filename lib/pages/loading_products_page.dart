import 'package:flutter/material.dart';

class LoadingProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cargando terapias'),
      ),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xff5ec1c8),
        ),
      ),
    );
  }
}
