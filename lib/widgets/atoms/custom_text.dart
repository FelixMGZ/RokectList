import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

// Definimos los tamaños base
enum TextType { h1, h2, body, caption }

class CustomText extends StatelessWidget {
  final String text;
  final TextType type;
  
  // Opciones de personalización adicionales
  final Color? color;
  final TextAlign? align;
  final FontWeight? fontWeight;      // Para forzar negrita
  final FontStyle? fontStyle;        // Para cursiva
  final TextDecoration? decoration;  // Para tachado (strikethrough)
  final int? maxLines;               // Para limitar líneas
  final TextOverflow? overflow;      // Para poner "..." si es muy largo

  const CustomText(
    this.text, {
    super.key,
    this.type = TextType.body,
    this.color,
    this.align,
    this.fontWeight,
    this.fontStyle,
    this.decoration,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: _getBaseStyle().copyWith(
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: decoration,
      ),
    );
  }

  TextStyle _getBaseStyle() {
    switch (type) {
      case TextType.h1:
        return const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        );
      case TextType.h2:
        return const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        );
      case TextType.body:
        return const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        );
      case TextType.caption:
        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        );
    }
  }
}