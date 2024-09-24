import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.black45,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset('imagenes/Icons/house-chimney.svg',
            color: currentIndex == 0 ? Colors.orange : Colors.black45,),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('imagenes/Icons/store-alt.svg',
            color: currentIndex == 1 ? Colors.orange : Colors.black45,),
          label: 'Tiendas',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('imagenes/Icons/grocery-basket.svg',
            color: currentIndex == 2 ? Colors.orange : Colors.black45,),
          label: 'Carrito',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('imagenes/Icons/user-volunteer.svg',
            color: currentIndex == 3 ? Colors.orange : Colors.black45,),
          label: 'Usuario',
        ),
      ],
    );
  }
}
