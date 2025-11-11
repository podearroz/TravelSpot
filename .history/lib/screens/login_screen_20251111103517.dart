import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

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
    final ok = await FirebaseService.signInWithEmail(
        _emailController.text.trim(), _passwordController.text.trim());
    setState(() => _loading = false);
    if (ok) Navigator.pushReplacementNamed(context, '/home');
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao autenticar')),
      );
    }
  }

  Future<void> _googleSignIn() async {
    setState(() => _loading = true);
    final ok = await FirebaseService.signInWithGoogle();
    setState(() => _loading = false);
    if (ok) Navigator.pushReplacementNamed(context, '/home');
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
            ElevatedButton.icon(
              onPressed: _loading ? null : _googleSignIn,
              icon: const Icon(Icons.login),
              label: const Text('Entrar com Google'),
            ),
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
