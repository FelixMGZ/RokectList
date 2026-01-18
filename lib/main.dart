import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/home_page.dart'; 
import 'pages/login_page.dart'; 
import 'pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ekepftcoylunekhxmlta.supabase.co',
    anonKey: 'sb_publishable_KCwGUhrqvefTbkHUXo6vNQ_FyQsw7YY',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Proyectos',
      debugShowCheckedModeBanner: false,
      initialRoute: '/', 
      routes: {
        '/': (context) => const SplashPage(), // Página de inicio (splash)
        '/login': (context) => const LoginPage(), // Página de inicio de sesión
        '/home': (context) => const HomePage(), // Página principal
      },
    );
  }
}