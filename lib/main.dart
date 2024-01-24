import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String qrValue = "";

  void scanQr() async {
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
          setState(() {
            var data2 = jsonDecode(response2.body);
            var tipo = data2['tipo'];
            if(tipo=='entrada'){
              qrValue = "Entrada: ${data['nombre']}";
            }
            else{
              qrValue = "Salida: ${data['nombre']}";
            }
          });
        } else {
          setState(() {
            qrValue = "Error en la solicitud POST: ${response2.statusCode}";
          });
        }
      } else {
        setState(() {
          qrValue = "Error en la solicitud GET: ${response.statusCode}";
        });
      }
    } else {
      // Si la cadena escaneada no contiene "RUN=", puedes manejarlo de la manera que desees
      setState(() {
        qrValue = "No se encontró el formato esperado";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Code Scanner',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('QR Code Scanner'),
        ),
        body: Column(
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () => scanQr(),
          child: const Icon(Icons.camera),
        ),
      ),
    );
  }
}
