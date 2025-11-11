import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/add_place_screen.dart';
import 'services/supabase_service.dart';
import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicialize o Supabase com suas credenciais em lib/config.dart
  await Supabase.initialize(url: Config.supabaseUrl, anonKey: Config.supabaseAnonKey);
  await SupabaseService.initialize();
  runApp(const TravelSpotApp());
}

class TravelSpotApp extends StatelessWidget {
  const TravelSpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelSpot',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/add': (context) => const AddPlaceScreen(),
      },
    );
  }
}
