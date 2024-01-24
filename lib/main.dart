import 'package:flutter/material.dart';
import 'package:gestionautos/pages/SecondScreen.dart';
import 'package:gestionautos/pages/VistaQr.dart';
import 'package:gestionautos/pages/page_404.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _routes = {
    '/': (context) => const VistaQr(),
    '/persona': (context) => const SecondScreen(data: {},),
  };

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Configuración del tema claro
        //seleccionar fuente desde google fonts
        brightness: Brightness.light,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Onest',
          ),
        ),
      ),
      darkTheme: ThemeData(
        // Configuración del tema oscuro
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Onest',
          ),
        ),
      ),
      initialRoute: "/",
      routes: _routes,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Page404(),
        );
      },
    );
  }
}
