import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../../utils/validators.dart';
import '../atoms/custom_button.dart';
import '../atoms/custom_input.dart';
import '../atoms/color_selector.dart';
import '../atoms/icon_selector.dart';
import '../molecules/custom_bottom_sheet.dart';
import '../atoms/custom_text.dart';

class ProjectFormModal extends StatefulWidget {
  final Project? projectToEdit;
  final Function(String title, String subtitle, int icon, int color) onSubmit;

  const ProjectFormModal({
    super.key,
    this.projectToEdit,
    required this.onSubmit,
  });

  static void show(BuildContext context, {Project? projectToEdit, required Function(String, String, int, int) onSubmit}) {
    CustomBottomSheet.show(
      context,
      title: projectToEdit == null ? "Nuevo Proyecto" : "Editar Proyecto",
      child: ProjectFormModal(projectToEdit: projectToEdit, onSubmit: onSubmit),
    );
  }

  @override
  State<ProjectFormModal> createState() => _ProjectFormModalState();
}

class _ProjectFormModalState extends State<ProjectFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late int _selectedColor;
  late int _selectedIcon;

  @override
  void initState() {
    super.initState();
    final p = widget.projectToEdit;
    _titleController = TextEditingController(text: p?.title ?? "");
    _subtitleController = TextEditingController(text: p?.subtitle ?? "");
    _selectedColor = p?.color ?? 0xFF2196F3;
    _selectedIcon = p?.icon ?? 58136;        
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    
    widget.onSubmit(
      _titleController.text,
      _subtitleController.text,
      _selectedIcon,
      _selectedColor,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInput(
            label: "Nombre",
            hint: "Ej: App de Gym",
            controller: _titleController,
            validator: Validators.required,
          ),
          const SizedBox(height: 15),
          CustomInput(
            label: "Descripción",
            hint: "Ej: Rutinas de ejercicio",
            controller: _subtitleController,
            validator: Validators.required,
          ),
          
          const SizedBox(height: 20),
          
          const CustomText(
            "Color:", 
            type: TextType.body, 
            fontWeight: FontWeight.bold
          ),
          
          const SizedBox(height: 10),
          ColorSelector(
            selectedColor: _selectedColor,
            onColorSelected: (color) => setState(() => _selectedColor = color),
          ),

          const SizedBox(height: 20),

          const CustomText(
            "Icono:", 
            type: TextType.body, 
            fontWeight: FontWeight.bold
          ),
          
          const SizedBox(height: 10),
          IconSelector(
            selectedIconCode: _selectedIcon,
            onIconSelected: (icon) => setState(() => _selectedIcon = icon),
          ),

          const SizedBox(height: 25),
          CustomButton(
            text: widget.projectToEdit == null ? "Crear Proyecto" : "Guardar Cambios",
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}