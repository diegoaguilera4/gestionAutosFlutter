import 'package:flutter/material.dart';

class Page404 extends StatefulWidget {
  const Page404({super.key});

  @override
  State<Page404> createState() => Page404State();
}

class Page404State extends State<Page404> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Page 404'),
      ),
    );
  }
}