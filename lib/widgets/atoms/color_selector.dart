import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
 
  final int selectedColor;

  final Function(int) onColorSelected;

  // NUESTRA PALETA DE COLORES DISPONIBLES
  final List<int> _colors = [
    0xFF2196F3, // Azul (Default)
    0xFF4CAF50, // Verde
    0xFFFFC107, // Amarillo
    0xFFFF5252, // Rojo
    0xFF9C27B0, // Morado
    0xFF607D8B, // Gris Azulado
    0xFFE91E63, // Rosa
  ];

  ColorSelector({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _colors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        itemBuilder: (context, index) {
          final colorValue = _colors[index];
          final isSelected = colorValue == selectedColor;

          return GestureDetector(
            onTap: () => onColorSelected(colorValue),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(colorValue),
                shape: BoxShape.circle,
                border: isSelected 
                  ? Border.all(color: Colors.black87, width: 3) 
                  : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white)
                  : null,
            ),
          );
        },
      ),
    );
  }
}