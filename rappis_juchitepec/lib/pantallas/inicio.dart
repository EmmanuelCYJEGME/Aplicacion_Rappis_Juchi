import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class InicioHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de categorías en forma de círculos
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCategoryItem('Mercado', Icons.shopping_cart),
                    _buildCategoryItem('Tiendas', Icons.store),
                    _buildCategoryItem('Antojos', Icons.fastfood),
                    _buildCategoryItem('Cocinas', Icons.kitchen),
                    _buildCategoryItem('Bebidas', Icons.local_drink),
                  ],
                ),
              ),
            ),

            // Carrusel de productos más comprados
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CarouselSlider(
                items: _buildCarouselItems(),
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
              ),
            ),

            // Lista dinámica de productos
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Productos Recomendados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildProductList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          child: Icon(icon, size: 30),
        ),
        SizedBox(height: 8),
        Text(title),
      ],
    );
  }

  List<Widget> _buildCarouselItems() {
    // Puedes obtener esta lista de productos más comprados desde un API o una lista local.
    return [
      _buildCarouselItem('Producto 1', 'url_de_imagen_1'),
      _buildCarouselItem('Producto 2', 'url_de_imagen_2'),
      _buildCarouselItem('Producto 3', 'url_de_imagen_3'),
    ];
  }

  Widget _buildCarouselItem(String title, String imageUrl) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Image.network(imageUrl, fit: BoxFit.cover, width: 1000.0),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    // Simulación de productos. Deberías obtener esta lista desde un API.
    final List<Map<String, String>> products = [
      {'name': 'Producto A', 'image': 'url_de_imagen_A'},
      {'name': 'Producto B', 'image': 'url_de_imagen_B'},
      {'name': 'Producto C', 'image': 'url_de_imagen_C'},
      // Agrega más productos aquí
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: [
              Image.network(
                products[index]['image']!,
                fit: BoxFit.cover,
                height: 100,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(products[index]['name']!),
              ),
            ],
          ),
        );
      },
    );
  }
}