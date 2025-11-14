import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/di/application_container.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'config.dart';
import 'core/services/supabase_service.dart';
import 'feature/auth/presentation/bloc/auth_bloc.dart';
import 'feature/auth/presentation/bloc/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carrega variáveis de ambiente do arquivo .env (Git ignore)
  await dotenv.load();
  
  final url = dotenv.env['SUPABASE_URL']?.isNotEmpty == true
      ? dotenv.env['SUPABASE_URL']!
      : Config.supabaseUrl;
  final anon = dotenv.env['SUPABASE_ANON_KEY']?.isNotEmpty == true
      ? dotenv.env['SUPABASE_ANON_KEY']!
      : Config.supabaseAnonKey;

  await Supabase.initialize(url: url, anonKey: anon);
  
  // Initialize Supabase service
  await SupabaseService.initialize();
  
  // Initialize dependency injection
  await ApplicationContainer.init();
  
  runApp(const TravelSpotApp());
}

class TravelSpotApp extends StatelessWidget {
  const TravelSpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => ApplicationContainer.resolve<AuthBloc>()
            ..add(AuthCheckRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'TravelSpot',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
