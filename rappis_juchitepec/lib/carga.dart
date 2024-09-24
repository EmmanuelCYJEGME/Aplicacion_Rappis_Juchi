import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';

void main() {
  runApp(Carga());
}

class Carga extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    Timer(
      Duration(seconds: 10),
          () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => MyApp(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo de la pantalla de carga
          Container(
            decoration: BoxDecoration(
              color: Colors.orange, // Color de fondo personalizable
            ),
          ),
          // Logo centrado en la pantalla
          Center(
            child: Image.asset(
              'imagenes/logorappis.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
