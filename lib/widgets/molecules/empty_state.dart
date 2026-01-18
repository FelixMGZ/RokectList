import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/atoms/custom_text.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(

              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 60,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 20),
          
          CustomText(
            title,
            type: TextType.h2,
            align: TextAlign.center, // <--- Mejoramos la alineación
          ),
          
          const SizedBox(height: 8),
          
          CustomText(
            message,
            type: TextType.caption, 
            align: TextAlign.center, // <--- Mejoramos la alineación
          ),
        ],
      ),
    );
  }
}