import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';

class TaskRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // 1. OBTENER TAREAS DE UN PROYECTO
  Future<List<Task>> getTasks(int projectId) async {
    final response = await _client
        .from('tasks')
        .select()
        .eq('project_id', projectId) // <--- LA CLAVE: Solo tareas de ESTE proyecto
        .order('id', ascending: true); // Ordenadas por creación

    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) => Task.fromJson(json)).toList();
  }

  // 2. CREAR TAREA NUEVA
 Future<void> addTask(String title, int projectId, {DateTime? dueDate}) async {
    
    final user = _client.auth.currentUser;
    if (user == null) throw Exception("No estás logueado");

    await _client.from('tasks').insert({
      'title': title,
      'project_id': projectId,
      'is_completed': false,
      'due_date': dueDate?.toIso8601String(), 
    });
  }
  // 3. ACTUALIZAR ESTADO
  Future<void> updateTaskStatus(int taskId, bool isCompleted) async {
    await _client.from('tasks').update({
      'is_completed': isCompleted,
    }).eq('id', taskId);
  }

  // 4. ELIMINAR TAREA
  Future<void> deleteTask(int taskId) async {
    await _client.from('tasks').delete().eq('id', taskId);
  }

  // EDICIÓN DE TAREA
  Future<void> updateTask(int taskId, {String? title, DateTime? dueDate}) async {
    
    final updates = <String, dynamic>{};
    if (title != null) updates['title'] = title;
    if (dueDate != null) updates['due_date'] = dueDate.toIso8601String();

    if (updates.isEmpty) return;

    await _client.from('tasks').update(updates).eq('id', taskId);
  }
}