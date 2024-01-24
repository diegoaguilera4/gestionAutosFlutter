import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  // Data property
  final data;

  SecondScreen({this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Nombre: ${data['nombre']}'),
            Text('RUT: ${data['rut']}'),
          ],
        ),
      ),
    );
  }
}
