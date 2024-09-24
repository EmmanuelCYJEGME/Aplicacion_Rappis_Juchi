import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../main.dart';
import 'registro.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyLoginPage(),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final response = await http.post(
      Uri.parse('http://192.168.1.220:3000/api/usuario/login'), // Reemplaza con tu URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'correo': email,
        'contrasena': password,
      }),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Si el servidor devuelve una respuesta OK, muestra el mensaje en una alerta
      String mensaje = responseBody['mensaje'];
      final token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Inicio de sesión exitoso"),
            content: Text(mensaje),
            actions: [
              TextButton(
                child: Text("Aceptar"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => MyApp(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      // Si la respuesta no es OK, muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.orange, // Usar Colors.orange ya que Colors.mainnaranja no es válido
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'imagenes/mascota.png',
                scale: 5.4,
                alignment: Alignment(-0.1, -0.7),
                fit: BoxFit.scaleDown,
              ),
            ),
            Positioned(
              top: 510,
              left: 40,
              child: Image.asset(
                'imagenes/letras_logo.png',
                width: 300,
                height: 200,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                // Permite hacer scroll si el contenido es muy grande
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        // Texto con contorno negro
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6 // Ajusta el grosor del contorno
                              ..color = Colors.black,
                          ),
                        ),
                        // Texto principal en color blanco
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Usuario o Correo',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true, // Oculta la contraseña
                        decoration: InputDecoration(
                          hintText: 'Contraseña',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Recuperar Contraseña',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navega a la página de registro
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegistroPage()),
                        );
                      },
                      child: Text(
                        'Registrarme',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _login,
                      child: Text('Iniciar Sesión'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
