import 'package:flutter/material.dart';

class IconSelector extends StatelessWidget {
  final int selectedIconCode;
  final Function(int) onIconSelected;

  // Lista de iconos disponibles para seleccionar
  final List<IconData> _icons = [
    Icons.home,           // Casa
    Icons.work,           // Maletín
    Icons.code,           // Código
    Icons.fitness_center, // Pesa
    Icons.flight,         // Avión
    Icons.shopping_cart,  // Carrito
    Icons.school,         // Gorro graduación
    Icons.pets,           // Huella
  ];

  IconSelector({
    super.key,
    required this.selectedIconCode,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _icons.length,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        itemBuilder: (context, index) {
          final iconData = _icons[index];
          final isSelected = iconData.codePoint == selectedIconCode;

          return GestureDetector(
            onTap: () => onIconSelected(iconData.codePoint),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? Colors.black87 : Colors.grey[200],
                shape: BoxShape.circle,
                border: isSelected 
                  ? Border.all(color: Colors.black87, width: 2) 
                  : null,
              ),
              child: Icon(
                iconData,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          );
        },
      ),
    );
  }
}