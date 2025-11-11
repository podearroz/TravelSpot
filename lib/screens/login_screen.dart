import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _signIn() async {
    setState(() => _loading = true);
    final ok = await SupabaseService.signInWithEmail(
        _emailController.text.trim(), _passwordController.text.trim());
    setState(() => _loading = false);
    if (ok)
      Navigator.pushReplacementNamed(context, '/home');
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao autenticar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login - TravelSpot')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _signIn,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Entrar'),
            ),
            const SizedBox(height: 8),
            // Entrada social pode ser adicionada via Supabase OAuth no futuro
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Criar conta'),
            ),
          ],
        ),
      ),
    );
  }
}
