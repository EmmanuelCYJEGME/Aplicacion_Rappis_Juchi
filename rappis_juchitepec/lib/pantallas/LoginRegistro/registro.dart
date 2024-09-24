import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';
import 'login.dart';

class RegistroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyRegistroPage(),
    );
  }
}

class MyRegistroPage extends StatefulWidget {
  @override
  _MyRegistroPage createState() => _MyRegistroPage();
}

class _MyRegistroPage extends State<MyRegistroPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreUsuario = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _Confirmarcontra = TextEditingController();
  final TextEditingController _NombreReal = TextEditingController();
  final TextEditingController _codigo = TextEditingController();

  Future<void> _Registrar() async {
    final String usuario = _nombreUsuario.text;
    final String NombreReal = _NombreReal.text;
    final String email = _emailController.text;
    final String password = _contrasenaController.text;
    final String ConfirmarContra= _Confirmarcontra.text;

    final response = await http.post(
      Uri.parse('http://192.168.1.220:3000/api/usuario/registrar'), // Reemplaza con tu URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'usuario': usuario,
        'nombreReal': NombreReal,
        'confrimarContrasena': ConfirmarContra,
        'correo': email,
        'contrasena': password,
      }),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // Si el servidor devuelve una respuesta OK, muestra el mensaje en una alerta
      String mensaje = responseBody['mensaje'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Registro Exitoso"),
            content: Column(
              mainAxisSize: MainAxisSize.min,children: [
              Text(mensaje),
              TextFormField(
                maxLength: 5,
                controller: _codigo,
                decoration: InputDecoration(labelText: "Código de Verificación"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese elcódigo';
                  }
                  if (value.length != 5) {
                    return 'El código debe tener 5 caracteres';
                  }
                  return null;
                },
              ),
            ],
            ),
            actions: [
              TextButton(
                child: Text("Validar Correo"),
                onPressed: () {
                  _ValidarCorreo();
                },
              ),],
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

  Future<void> _ValidarCorreo() async{
    final String Codigo = _codigo.text;
    final response = await http.post(
      Uri.parse('http://192.168.1.220:3000/api/usuario/ValidarCorreo'), // Reemplaza con tu URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'codigo': Codigo,
      }),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // Si el servidor devuelve una respuesta OK, muestra el mensaje en una alerta
      String mensaje = responseBody['mensaje'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Validacion Exitosa"),
            content: Text(mensaje),
            actions: [
              TextButton(
                child: Text("Aceptar"),
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
    } else {
      // Si la respuesta no es OK, muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al validar el correo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Registro"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldPop = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('¿Seguro que quieres salir del registro?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // No salir
                        },
                        child: Text('No', style: TextStyle(color: Colors.red)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // Sí salir
                        },
                        child: Text('Sí', style: TextStyle(color: Colors.green)),
                      ),
                    ],
                  );
                },
              );
              if (shouldPop ?? false) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                      (Route<dynamic> route) => false,
                );
              }
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.orange,
          ),
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nombreUsuario,
                  decoration: InputDecoration(
                    labelText: 'Nombre de usuario',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un nombre de usuario';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _NombreReal,
                  decoration: InputDecoration(
                    labelText: 'Nombre de completo',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa su nombre Completo';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su correo electrónico';
                    }
                    if (!value.contains('@')) {
                      return 'Por favor ingrese un correo electrónico válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contrasenaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su contraseña';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _Confirmarcontra,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmar contraseña',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su contraseña';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Procesando datos')),
                      );
                      _Registrar();
                    }
                  },
                  child: Text('Registrarse'),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
