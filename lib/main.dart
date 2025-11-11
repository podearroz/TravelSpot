import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/add_place_screen.dart';
import 'services/supabase_service.dart';
import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Carrega variáveis de ambiente do arquivo .env (crie .env a partir de .env.example)
  await dotenv.load();

  final url = dotenv.env['SUPABASE_URL']?.isNotEmpty == true
      ? dotenv.env['SUPABASE_URL']!
      : Config.supabaseUrl;
  final anon = dotenv.env['SUPABASE_ANON_KEY']?.isNotEmpty == true
      ? dotenv.env['SUPABASE_ANON_KEY']!
      : Config.supabaseAnonKey;

  await Supabase.initialize(url: url, anonKey: anon);
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
