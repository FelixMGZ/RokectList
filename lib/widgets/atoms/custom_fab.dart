import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class CustomFab extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const CustomFab({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.primary,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), 
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}