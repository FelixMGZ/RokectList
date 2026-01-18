import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/project_model.dart';

class ProjectRepository {

  final SupabaseClient _client = Supabase.instance.client;

  // 1. Obtener Proyectos
  Future<List<Project>> getProjects() async {
    final response = await _client.from('projects').select('*, tasks(*)');
    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) => Project.fromJson(json)).toList();
  }

  // 2. Agregar Proyecto
  Future<void> addProject({
    required String title,
    required String subtitle,
    required int iconCode,
    required int colorValue,
  }) async {
    final String userId = _client.auth.currentUser!.id;
    await _client.from('projects').insert({
      'title': title,
      'subtitle': subtitle,
      'icon_code': iconCode,
      'color_value': colorValue,
      'user_id': userId,
    });
  }

  // 3. Eliminar Proyecto
  Future<void> deleteProject(int id) async {
    await _client.from('projects').delete().eq('id', id);
  }

  // 4. Actualizar Proyecto
  Future<void> updateProject({
    required int id,
    required String title,
    required String subtitle,
    required int iconCode,
    required int colorValue,
  }) async {
    await _client.from('projects').update({
      'title': title,
      'subtitle': subtitle,
      'icon_code': iconCode,
      'color_value': colorValue,
    }).eq('id', id);
  }
} 
