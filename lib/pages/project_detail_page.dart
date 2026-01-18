import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/project_model.dart';
import '../models/task_model.dart';
import '../widgets/atoms/custom_text.dart';
import '../widgets/molecules/task_item.dart';
import '../repositories/task_repository.dart';
import '../repositories/project_repository.dart';
import '../widgets/molecules/project_form_modal.dart';
import '../core/app_colors.dart';
import '../widgets/molecules/empty_state.dart';

class ProjectDetailPage extends StatefulWidget {
  final Project project;

  const ProjectDetailPage({super.key, required this.project});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  final TaskRepository _taskRepository = TaskRepository();
  final ProjectRepository _projectRepository = ProjectRepository();
  
  final TextEditingController _taskController = TextEditingController();
  late Future<List<Task>> _tasksFuture;
  late Project _currentProject;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentProject = widget.project;
    _loadTasks();
  }

  void _loadTasks() {
    setState(() {
      _tasksFuture = _taskRepository.getTasks(_currentProject.id);
    });
  }

  // --- LÓGICA DE CREACIÓN ---
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _addTask() async {
    if (_taskController.text.isEmpty) return;
    try {
      await _taskRepository.addTask(
        _taskController.text, 
        _currentProject.id,
        dueDate: _selectedDate 
      );
      
      _taskController.clear();
      setState(() => _selectedDate = null); 
      _loadTasks();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomText("Error: $e", color: Colors.white)
        )
      );
    }
  }

  // --- LÓGICA DE EDICIÓN ---
  Future<void> _showEditTaskDialog(Task task) async {
    final editTitleController = TextEditingController(text: task.title);
    DateTime? editDate = task.dueDate;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: const CustomText("Editar Tarea", type: TextType.h2),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: editTitleController,
                    decoration: const InputDecoration(labelText: "Nombre de la tarea"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const CustomText("Vencimiento: ", type: TextType.body),
                      TextButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: CustomText(
                          editDate != null 
                            ? DateFormat('dd/MM/yyyy').format(editDate!) 
                            : "Sin fecha",
                          type: TextType.body,
                          color: AppColors.primary,
                        ),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: editDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setDialogState(() => editDate = picked);
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const CustomText("Cancelar", type: TextType.body, color: AppColors.textSecondary),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () async {
                    if (editTitleController.text.isNotEmpty) {
                      await _taskRepository.updateTask(
                        task.id,
                        title: editTitleController.text,
                        dueDate: editDate,
                      );
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      _loadTasks();
                    }
                  },
                  child: const CustomText("Guardar", type: TextType.body, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- LÓGICA DE GESTIÓN ---
  Future<void> _toggleTask(Task task) async {
    try {
      await _taskRepository.updateTaskStatus(task.id, !task.isCompleted);
      _loadTasks();
    } catch (e) { 
      debugPrint("Error al actualizar estado de tarea $e");
    }
  }

  Future<void> _deleteTask(int taskId) async {
    try {
      await _taskRepository.deleteTask(taskId);
      _loadTasks();
    } catch (e) { 
      debugPrint("Error al eliminar tarea $e"); 
    }
  }

  void _editProject() {
    ProjectFormModal.show(
      context,
      projectToEdit: _currentProject,
      onSubmit: (title, subtitle, icon, color) async {
        try {
          await _projectRepository.updateProject(
            id: _currentProject.id,
            title: title,
            subtitle: subtitle,
            iconCode: icon,
            colorValue: color,
          );

          setState(() {
            _currentProject = Project(
              id: _currentProject.id,
              title: title,
              subtitle: subtitle,
              icon: icon,
              color: color,
              totalTasks: _currentProject.totalTasks,
              completedTasks: _currentProject.completedTasks,
            );
          });
        } catch (e) { debugPrint("Error al actualizar proyecto $e"); }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: CustomText(_currentProject.title, type: TextType.h2),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primary),
            onPressed: _editProject,
          ),
        ],
      ),
      body: Column(
        children: [
          // ENCABEZADO
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface, 
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(_currentProject.color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      IconData(_currentProject.icon, fontFamily: 'MaterialIcons'), 
                      size: 30, 
                      color: Color(_currentProject.color)
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText("Detalles del Proyecto", type: TextType.body),
                        const SizedBox(height: 5),
                        CustomText(_currentProject.subtitle, type: TextType.body),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // INPUT NUEVA TAREA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _taskController,
                        decoration: InputDecoration(
                          hintText: "Agregar nueva tarea...",
                          hintStyle: const TextStyle(color: AppColors.textSecondary),
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.calendar_today_rounded, 
                              color: _selectedDate != null ? AppColors.primary : AppColors.textSecondary
                            ),
                            onPressed: _pickDate,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FloatingActionButton(
                      mini: true,
                      backgroundColor: AppColors.primary, 
                      onPressed: _addTask,
                      child: const Icon(Icons.add, color: Colors.white),
                    )
                  ],
                ),
                
                if (_selectedDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 10),
                    child: Chip(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      label: CustomText(
                        "Vence: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}",
                        type: TextType.caption,
                        color: AppColors.primary,
                      ),
                      deleteIcon: const Icon(Icons.close, size: 16, color: AppColors.primary),
                      onDeleted: () {
                        setState(() => _selectedDate = null);
                      },
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),

          // LISTA DE TAREAS
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: AppColors.surface, 
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),

              child: FutureBuilder<List<Task>>(
                future: _tasksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: CustomText("Error: ${snapshot.error}", color: AppColors.error)
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: EmptyState(
                        title: "Sin tareas",
                        message: "Escribe arriba para agregar\ncosas por hacer.",
                        icon: Icons.check_circle_outline_rounded,
                      ),
                    );
                  }

                  final tasks = snapshot.data!;
                  
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 25, bottom: 20),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      
                      bool isOverdue = false;
                      String dateText = "";
                      
                      if (task.dueDate != null) {
                        dateText = DateFormat('dd MMM').format(task.dueDate!);
                        if (task.dueDate!.isBefore(DateTime.now()) && !task.isCompleted) {
                          isOverdue = true;
                          dateText += " (Vencida)";
                        }
                      }
                        
                      return Column(
                        children: [
                          TaskItem(
                            task: task,
                            onToggle: (value) => _toggleTask(task),
                            onDelete: () => _deleteTask(task.id),
                            onLongPress: () => _showEditTaskDialog(task),
                          ),
                          if (task.dueDate != null)
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(bottom: 15, left: 10),
                              child: CustomText(
                                "📅 $dateText",
                                type: TextType.caption, 
                                fontWeight: FontWeight.bold, 
                                color: isOverdue ? AppColors.error : AppColors.textSecondary,
                              ),
                            )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}