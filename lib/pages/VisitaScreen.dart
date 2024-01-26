import 'package:flutter/material.dart';

class VisitaScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const VisitaScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      data['tipo'] == 'entrada'
                          ? 'assets/images/icono-entrada.png'
                          : 'assets/images/icono-salida.png',
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Text(
                data['tipo'] == 'entrada' ? 'Ha entrado de visita:' : 'Ha salido de visita:',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Onest',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                data['nombre'],
                style: const TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Onest',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Rut: ${data['rut']}',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Onest',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Motivo: ${data['motivo']}',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Onest',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: SizedBox(
                width: 200.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF126aa3),
                  ),
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Onest',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
