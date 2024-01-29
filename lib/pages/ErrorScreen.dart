import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  // Asegúrate de que 'data' no esté siendo inicializado como nulo aquí
  const ErrorScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/icono-error.png'),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Text(
                    'Error: ${data['error']}',
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontFamily: 'Onest',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 700),
                child: SizedBox(
                  width:
                      200.0, // Ajusta este valor para cambiar el ancho del botón
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFF126aa3), // Cambia 'red' por el color que prefieras
                    ),
                    child: const Text(
                      'Aceptar',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Onest',
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
