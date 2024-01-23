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
  String qrValue = "Código QR";

  void scanQr() async {
    String? cameraScanResult = await scanner.scan();

    // Verifica si la cadena escaneada contiene "RUN=" antes de intentar extraer la parte específica
    if (cameraScanResult != null && cameraScanResult.contains("RUN=")) {
      // Encuentra el índice de "RUN=" en la cadena
      int startIndex = cameraScanResult.indexOf("RUN=");

      // Encuentra el índice del primer carácter "-" después de "RUN="
      int endIndex = cameraScanResult.indexOf("-", startIndex + 4) + 2;

      // Extrae la parte de la cadena después de "RUN=" hasta el carácter "-"
      String extractedPart = cameraScanResult.substring(startIndex + 4, endIndex);
      print("RUN: $extractedPart");
      setState(() {
        qrValue = extractedPart;
      });

      // Realiza la solicitud GET
      await performGetRequest(extractedPart);

      // Realiza la solicitud POST
      await performPostRequest(extractedPart);

      

      // Actualiza el estado de la aplicación
    } else {
      // Si la cadena escaneada no contiene "RUN=", puedes manejarlo de la manera que desees
      setState(() {
        qrValue = "No se encontró el formato esperado";
      });
    }
  }

  Future<void> performGetRequest(String rut) async {
    // Aquí realiza tu solicitud GET al servidor con el rut
    // Por ejemplo:
    String apiUrl = "http://172.28.199.144:3000/personas/obtenerRut/$rut";
    http.Response response = await http.get(Uri.parse(apiUrl));
    print(response.body);
  }

  Future<void> performPostRequest(String rut) async {
    // Aquí realiza tu solicitud POST al servidor con el rut
    // Por ejemplo:
    String apiUrl = "http://172.28.199.144:3000/registros/agregar";
    Map<String, String> body = {"rut": rut};
    http.Response response = await http.post(Uri.parse(apiUrl), body: body);
    print(response.body);
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
        body: Center(
          child: Text(
            qrValue,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
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
