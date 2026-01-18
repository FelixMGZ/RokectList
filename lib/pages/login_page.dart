import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/atoms/custom_button.dart';
import '../widgets/atoms/custom_input.dart';
import '../widgets/atoms/custom_text.dart';
import '../repositories/auth_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthRepository _authRepository = AuthRepository();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLogin = true; 
  bool _isLoading = false;

  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: CustomText("Por favor llena todos los campos", color: Colors.white),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await _authRepository.signIn(email, password);
      } else {
        await _authRepository.signUp(email, password);
      }

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText("Error: ${e.toString()}", color: Colors.white),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LOGO 
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.rocket_launch_rounded,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // TÍTULO Y SUBTÍTULO
              Center(
                child: CustomText(
                  _isLogin ? "¡Hola de nuevo!" : "Crea tu cuenta",
                  type: TextType.h1,
                ),
              ),
              const SizedBox(height: 10),
              
              Center(
                child: CustomText(
                  _isLogin 
                    ? "Ingresa para gestionar tus proyectos" 
                    : "Únete y empieza a organizarte",
                  type: TextType.body,
                  color: AppColors.textSecondary,
                  align: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 40),

              // FORMULARIO DE LOGIN/REGISTRO
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    CustomInput(
                      label: "Correo Electrónico",
                      hint: "ejemplo@correo.com",
                      controller: _emailController,
                    ),
                    const SizedBox(height: 20),
                    CustomInput(
                      label: "Contraseña",
                      hint: "******",
                      controller: _passwordController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 30),
                    
                    // BOTÓN PRINCIPAL DE LOGIN/REGISTRO
                    CustomButton(
                      text: _isLogin ? "Iniciar Sesión" : "Registrarse",
                      onPressed: _handleSubmit,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              //SWITCH LOGIN/REGISTRO 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    _isLogin ? "¿No tienes cuenta? " : "¿Ya tienes cuenta? ",
                    type: TextType.body,
                    color: AppColors.textSecondary,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _isLogin = !_isLogin);
                    },
                    child: CustomText(
                      _isLogin ? "Regístrate aquí" : "Ingresa aquí",
                      type: TextType.body, 
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold, 
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}