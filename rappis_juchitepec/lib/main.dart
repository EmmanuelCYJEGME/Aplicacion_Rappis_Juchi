import 'package:flutter/material.dart';
import 'pantallas/TiendasPage.dart';
import 'pantallas/CarritoPage.dart';
import 'pantallas/UsuarioPage.dart';
import 'pantallas/inicio.dart';
import 'pantallas/LoginRegistro/login.dart';
import 'bottom_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Cabeza principal
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Rappi's Demo",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Rappi's Juchi"),
    );
  }
}

// Contenedor de navegador
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _refreshToken();
  }

  Future<void> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token != null) {
      final response = await http.post(
        Uri.parse('http://192.168.1.220:3000/api/usuario/renovarToken'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newToken = data['token'];

        await prefs.setString('authToken', newToken);
      } else {
        // Mostrar modal si el token es inválido
        _showInvalidTokenDialog(context);
      }
    } else {
      _showInvalidTokenDialog(context);
    }
  }
  void _showInvalidTokenDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Inicia Sesión'),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el modal
                },
              ),
            ],
          ),
          content: Text(
            'No has iniciado sesión. Algunas funciones pueden no estar disponibles.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Iniciar sesión'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Barra de navegación
  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    switch (_currentIndex) {
      case 0:
        currentPage = InicioHome();
        break;
      case 1:
        currentPage = TiendasPage();
        break;
      case 2:
        currentPage = CarritoPage();
        break;
      case 3:
        currentPage = UsuarioPage();
        break;
      default:
        currentPage = InicioHome();
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130.0), // Altura ajustada del AppBar
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(16.0), // Espaciado alrededor de los elementos
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end, // Alinea los elementos al final para dar espacio
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacio entre los elementos
                  children: [
                    IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: () {
                        // Acción para el botón de ubicación
                      },
                    ),
                    Expanded(
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24, // Tamaño más grande para el título
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        // Acción para el botón de carrito de compras
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Espacio entre el título y la barra de búsqueda
                TextField(
                  decoration: InputDecoration(
                    hintText: '¿Qué se te antoja hoy?',
                    hintStyle: const TextStyle(color: Colors.orangeAccent, fontSize: 15),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: currentPage,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
