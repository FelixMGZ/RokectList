import 'package:flutter/material.dart';
import 'package:mi_arquitectura_base/widgets/atoms/custom_text.dart';
import '../../models/task_model.dart';
import '../../core/app_colors.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onDelete;
  final VoidCallback onLongPress;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: const CustomText("¿Borrar tarea?", type: TextType.h2),
              content: const CustomText("Esta acción no se puede deshacer.", type: TextType.body),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const CustomText("Cancelar", type: TextType.body, color: AppColors.textSecondary),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const CustomText("Eliminar", type: TextType.body, color: AppColors.error, fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        onDelete();
      },

      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: onToggle,
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              Expanded(
                child: CustomText(
                  task.title,
                  type: TextType.body,
                  color: task.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              const Icon(Icons.edit, size: 16, color: AppColors.border),
            ],
          ),
        ),
      ),
    );
  }
}