import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  final data;

  // Asegúrate de que 'data' no esté siendo inicializado como nulo aquí
  const SecondScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            // Asegúrate de que 'data' no sea nulo al acceder a sus propiedades
            Text('Nombre: ${data['nombre'] ?? 'Sin nombre'}'),
          ],
        ),
      ),
    );
  }
}
