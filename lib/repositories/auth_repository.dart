import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // 1. Iniciar Sesión
  Future<void> signIn(String email, String password) async {
    await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // 2. Registrarse (Crear cuenta nueva)
  Future<void> signUp(String email, String password) async {
    await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  // 3. Cerrar Sesión
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // 4. Obtener usuario actual (¿Hay alguien logueado?)
  User? get currentUser => _client.auth.currentUser;
}