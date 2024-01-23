import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

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

      setState(() {
        qrValue = extractedPart;
      });
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
