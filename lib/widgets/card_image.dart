import 'dart:io';

import 'package:flutter/material.dart';

class GeneralImage extends StatelessWidget {
  final String? url;

  const GeneralImage({
    Key? key,
    this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Container(
        decoration: _buildBoxDecoration(),
        width: double.infinity,
        height: 450.0,
        child: Opacity(
          opacity: 0.8,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45.0),
              topRight: Radius.circular(45.0),
            ),
            child: getImage(url),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45.0),
          topRight: Radius.circular(45.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0, 5),
          ),
        ],
      );

  Widget getImage(String? imagen) {
    if (imagen == null)
      return Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
      );
    if (imagen.startsWith('http'))
      return FadeInImage(
        placeholder: AssetImage('assets/loading.gif'),
        image: NetworkImage(url!),
        fit: BoxFit.cover,
      );

    return Image.file(
      File(imagen),
      fit: BoxFit.cover,
    );
  }
}
