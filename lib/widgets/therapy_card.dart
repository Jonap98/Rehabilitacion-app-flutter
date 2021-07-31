import 'package:flutter/material.dart';

import 'package:rehabilitacion_app/models/therapy.dart';

class TherapyCard extends StatelessWidget {
  final Therapy therapy;

  const TherapyCard({
    Key? key,
    required this.therapy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        margin: EdgeInsets.only(top: 20.0, bottom: 50.0),
        width: double.infinity,
        height: 400.0,
        decoration: _cardBorders(),
        child: Stack(
          // alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(url: therapy.imagen),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 20.0,
              child: _Details(
                name: therapy.nombre,
                id: 'Código: ${therapy.id}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 7),
            blurRadius: 10.0,
          ),
        ],
      );
}

class _Details extends StatelessWidget {
  final String name;
  final String? id;

  const _Details({
    Key? key,
    required this.name,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 50.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        width: double.infinity,
        height: 70.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          color: Color(0xff5ec1c8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              id!,
              style: TextStyle(
                // fontSize: 20.0,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  final String? url;

  _BackgroundImage({
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: url == null
            ? Image(
                image: AssetImage('assets/no-image.png'),
                fit: BoxFit.cover,
              )
            : FadeInImage(
                placeholder: AssetImage('assets/loading.gif'),
                image: NetworkImage(url!),
                // image: NetworkImage('https://via.placeholder.com/400x300'),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
