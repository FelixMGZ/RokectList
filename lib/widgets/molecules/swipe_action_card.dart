import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'list_item.dart';

class SwipeActionCard extends StatelessWidget {
  final Key keyId;
  final String title;
  final String subtitle;
  final int icon;
  final int iconColor;
  final double progress;
  final String progressText;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const SwipeActionCard({
    required this.keyId,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onDelete,
    required this.onTap,
    this.progress = 0.0,
    this.progressText = "",
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: keyId,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
      ),

      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: const Text("¿Eliminar proyecto?", style: TextStyle(fontWeight: FontWeight.bold)),
              content: const Text("Esta acción borrará el proyecto y todas sus tareas. No se puede deshacer."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancelar", style: TextStyle(color: AppColors.textSecondary)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Eliminar", style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
      
      onDismissed: (direction) {
        onDelete();
      },

      child: ListItem(
        title: title,
        subtitle: subtitle,
        icon: icon,
        iconColor: iconColor,
        progress: progress,
        progressText: progressText,
        onTap: onTap,
      ),
    );
  }
}