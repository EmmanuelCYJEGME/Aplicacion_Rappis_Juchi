import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginRegistro/login.dart';
import 'LoginRegistro/registro.dart';

class UsuarioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final prefs = snapshot.data!;
        final token = prefs.getString('authToken');

        return Scaffold(
          appBar: AppBar(
            title: Text('Usuario'),
          ),
          body: Center(
            child: token == null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage()),
                      );
                    },
                    child: Text('Inicio de Sesión'),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistroPage()),
                      );
                    },
                    child: Text('Registro'),
                  ),
                ),
              ],
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navega a la página de "Mi Dirección"
                    },
                    child: Text('Mi Dirección'),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navega a la página de "Mis Favoritos"
                    },
                    child: Text('Mis Favoritos'),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navega a la página de "Comentarios"
                    },
                    child: Text('Comentarios'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
