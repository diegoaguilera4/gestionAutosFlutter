import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestionautos/pages/SecondScreen.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class VistaQr extends StatefulWidget {
  const VistaQr({Key? key}) : super(key: key);

  @override
  _VistaQrState createState() => _VistaQrState();
}

class _VistaQrState extends State<VistaQr> {
  String qrValue = "";

  void scanQr() async {
    // Solicitar permiso de cámara
    var status = await Permission.camera.request();

    if (status.isGranted) {
      String? cameraScanResult = await scanner.scan();

      // Verifica si la cadena escaneada contiene "RUN=" antes de intentar extraer la parte específica
      if (cameraScanResult != null && cameraScanResult.contains("RUN=")) {
        // Encuentra el índice de "RUN=" en la cadena
        int startIndex = cameraScanResult.indexOf("RUN=");

        // Encuentra el índice del primer carácter "-" después de "RUN="
        int endIndex = cameraScanResult.indexOf("-", startIndex + 4) + 2;

        // Extrae la parte de la cadena después de "RUN=" hasta el carácter "-"
        String extractedPart =
            cameraScanResult.substring(startIndex + 4, endIndex);

        // Realiza la solicitud GET
        String apiUrl =
            "http://172.28.199.144:3000/personas/obtenerRut/$extractedPart";
        var response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          // Realiza la solicitud POST
          var data = jsonDecode(response.body);
          String apiUrl2 = "http://172.28.199.144:3000/registros/agregar";
          Map<String, dynamic> requestBody = {
            'persona': data['_id'],
          };
          var response2 = await http.post(
            Uri.parse(apiUrl2),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          );

          if (response2.statusCode == 201) {
            //enviar a la otra pantalla
            var data2 = jsonDecode(response2.body);
            Map<String, dynamic> persona = {
              'nombre': data['nombre'],
              'rut': data['rut'],
              'centro': data['d_cencos'],
              'cargo': data['d_cargo'],
              'tipo': data2['tipo'],
            };
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SecondScreen(data: persona),
              ),
            );
          } else {
            Map<String, dynamic> error = {
              'error': "Error en la solicitud POST: ${response2.statusCode}",
            };
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SecondScreen(data: error),
              ),
            );
          }
        } else {
          Map<String, dynamic> error = {
            'error': "Error en la solicitud GET: $response.statusCode",
          };
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SecondScreen(data: error),
            ),
          );
        }
      } else {
        Map<String, dynamic> error = {
          'error': "No se encontró el formato esperado",
        };
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SecondScreen(data: error),
          ),
        );
      }
    } else {
      // Permiso denegado, manejar según sea necesario
      Map<String, dynamic> error = {
          'error': "Permiso de cámara denegado",
        };
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SecondScreen(data: error),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  qrValue,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          Positioned(
            top: 100.0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: const Center(
                child: Text(
                  'Escanea el código QR',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Onest',
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100.0,
            child: SizedBox(
              width: 180,
              height: 180,
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: const Color(0xFF126aa3),
                  onPressed: () => scanQr(),
                  heroTag: null,
                  mini: false,
                  elevation: 5.0,
                  highlightElevation: 12.0,
                  child: const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
