import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  // Asegúrate de que 'data' no esté siendo inicializado como nulo aquí
  const SecondScreen({Key? key, required this.data}) : super(key: key);

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
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(data['tipo'] == 'entrada'
                            ? 'assets/images/icono-entrada.png'
                            : 'assets/images/icono-salida.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Text(
                    data['tipo'] == 'entrada' ? 'Ha entrado:' : 'Ha salido:',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Onest',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0), // Ajusta según tus necesidades
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0), // Ajusta según tus necesidades
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0), // Ajusta según tus necesidades
                  child: Text(
                    'Centro de costo: ${data['centro']}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Onest',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0), // Ajusta según tus necesidades
                  child: Text(
                    'Cargo: ${data['cargo']}',
                    style: const TextStyle(
                      fontSize: 18.0,
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
