import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/project_model.dart';
import '../widgets/atoms/custom_text.dart';
import '../repositories/project_repository.dart';
import '../widgets/atoms/custom_fab.dart';
import 'project_detail_page.dart';
import '../widgets/molecules/project_form_modal.dart';
import '../repositories/auth_repository.dart';
import '../widgets/molecules/swipe_action_card.dart';
import '../widgets/molecules/empty_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProjectRepository _repository = ProjectRepository();
  late Future<List<Project>> _projectsFuture;

  void _refreshList() {
    setState(() {
      _projectsFuture = _repository.getProjects();
    });
  }

  @override
  void initState() {
    super.initState();
    _projectsFuture = _repository.getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BACKGROUND COLOR
      backgroundColor: AppColors.background,

      // APP BAR
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const CustomText("Mis Proyectos", type: TextType.h2),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _refreshList,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.error),
            onPressed: () async {
              await AuthRepository().signOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
          ),
        ],
      ),

      // FLOATING ACTION BUTTON
      floatingActionButton: CustomFab(
        onPressed: () {
          ProjectFormModal.show(
            context,
            onSubmit: (title, subtitle, icon, color) async {
              try {
                await _repository.addProject(
                  title: title,
                  subtitle: subtitle,
                  iconCode: icon,
                  colorValue: color,
                );
                _refreshList();
                
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: CustomText("¡Proyecto creado!", color: Colors.white),
                  ),
                );
              } catch (e) {
                debugPrint("Error al crear proyecto: $e");
              }
            },
          );
        },
      ),

      // BODY
      body: FutureBuilder<List<Project>>(
        
        future: _projectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 10),
                  CustomText("Error: ${snapshot.error}", type: TextType.body),
                ],
              ),
            );
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyState(
              title: "No tienes proyectos",
              message: "Toca el botón + para crear\ntu primer proyecto.",
              icon: Icons.folder_open_rounded,
            );
          }

          final projects = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const CustomText("Recientes", type: TextType.h2),
              const SizedBox(height: 15),
              
              ...projects.map((project) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SwipeActionCard(
                    keyId: ValueKey(project.id), 
                    title: project.title,
                    subtitle: project.subtitle,
                    icon: project.icon,
                    iconColor: project.color,
                    progress: project.progress,
                    progressText: "${project.completedTasks}/${project.totalTasks}",
                    
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectDetailPage(project: project),
                        ),
                      );
                      _refreshList();
                    },
                    
                    onDelete: () async {
                      await _repository.deleteProject(project.id);
                      _refreshList(); 
                      
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(
                           content: CustomText("Proyecto eliminado correctamente", color: Colors.white),
                         ),
                      );
                    },
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}