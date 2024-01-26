import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestionautos/pages/SecondScreen.dart';
import 'package:gestionautos/pages/VisitaScreen.dart';
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
  bool isLoading = false;

  void scanQr() async {
    // Solicitar permiso de cámara
    var status = await Permission.camera.request();

    if (status.isGranted) {
      String? cameraScanResult = await scanner.scan();
      setState(() {
        isLoading = true; // Cambia el estado a "cargando"
      });

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
            "http://172.28.199.80:3000/personas/obtenerRut/$extractedPart";
        var response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          // Realiza la solicitud POST
          var data = jsonDecode(response.body);
          String apiUrl2 = "http://172.28.199.80:3000/registros/agregar";
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
            setState(() {
              isLoading = false; // Cambia el estado de vuelta a "no cargando"
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SecondScreen(data: persona),
              ),
            );
          } else {
            Map<String, dynamic> error = {
              'error': "Error en la solicitud POST: ${response2.statusCode}",
            };
            setState(() {
              isLoading = false; // Cambia el estado de vuelta a "no cargando"
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SecondScreen(data: error),
              ),
            );
          }
        } else {
          DateTime now = DateTime.now();
          String apiVisita =
              "http://172.28.199.80:3000/permisoVisitas/obtenerRut/$extractedPart/$now";
          var responseV = await http.get(Uri.parse(apiVisita));

          if (responseV.statusCode == 200) {
            var dataVisita = jsonDecode(responseV.body);
            String apiAgregarVisita =
                "http://172.28.199.80:3000/registroVisitas/agregar";
            Map<String, dynamic> requestVisita = {
              'permiso': dataVisita['_id'],
            };
            var responseV2 = await http.post(
              Uri.parse(apiAgregarVisita),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(requestVisita),
            );
            if (responseV2.statusCode == 201) {
              var dataV2 = jsonDecode(responseV2.body);
              Map<String, dynamic> visitaP = {
                'nombre': dataVisita['nombre'],
                'rut': dataVisita['rut'],
                'motivo': dataVisita['motivo'],
                'tipo': dataV2['tipo'],
              };

              setState(() {
                isLoading = false; // Cambia el estado de vuelta a "no cargando"
              });
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VisitaScreen(data: visitaP),
                ),
              );
            } else {
              Map<String, dynamic> error = {
                'error':
                    "Error en la solicitud POSTv2: ${responseV2.statusCode}",
              };
              setState(() {
                isLoading = false; // Cambia el estado de vuelta a "no cargando"
              });
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SecondScreen(data: error),
                ),
              );
            }
          } else if (responseV.statusCode == 404) {
            Map<String, dynamic> error = {
              'error': "La fecha no está dentro del rango de la visita.",
            };
            setState(() {
              isLoading = false; // Cambia el estado de vuelta a "no cargando"
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SecondScreen(data: error),
              ),
            );
          } else {
            Map<String, dynamic> error = {
              'error': "Error en la solicitud GETv2: $responseV.statusCode",
            };
            setState(() {
              isLoading = false; // Cambia el estado de vuelta a "no cargando"
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SecondScreen(data: error),
              ),
            );
          }
        }
      } else {
        Map<String, dynamic> error = {
          'error': "No se encontró el formato esperado",
        };
        setState(() {
          isLoading = false; // Cambia el estado de vuelta a "no cargando"
        });
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
      setState(() {
        isLoading = false; // Cambia el estado de vuelta a "no cargando"
      });
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
          isLoading
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(), // Indicador de carga
        ],
      ),
    );
  }
}
