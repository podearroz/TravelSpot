import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'generated/l10n/app_localizations.dart';
import 'core/di/application_container.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/api/supabase_rest_client.dart';
import 'config.dart';
import 'core/services/supabase_service.dart';
import 'feature/auth/presentation/bloc/auth_bloc.dart';
import 'feature/auth/presentation/bloc/auth_event.dart';
import 'feature/auth/presentation/bloc/auth_state.dart' as auth;
import 'feature/places/presentation/bloc/places_bloc.dart';
import 'feature/favorites/presentation/bloc/favorites_bloc.dart';
import 'feature/reviews/presentation/bloc/reviews_bloc.dart';

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

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Configurar navigatorKey no SupabaseRestClient para o interceptor de erro
    SupabaseRestClient.setNavigatorKey(navigatorKey);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => ApplicationContainer.resolve<AuthBloc>()
            ..add(AuthCheckRequested()),
        ),
        BlocProvider<PlacesBloc>(
          create: (context) => ApplicationContainer.resolve<PlacesBloc>(),
        ),
        BlocProvider<FavoritesBloc>(
          create: (context) => ApplicationContainer.resolve<FavoritesBloc>(),
        ),
        BlocProvider<ReviewsBloc>(
          create: (context) => ApplicationContainer.resolve<ReviewsBloc>(),
        ),
      ],
      child: BlocListener<AuthBloc, auth.AuthState>(
        listener: (context, state) {
          if (state is auth.AuthAuthenticated) {
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              AppRoutes.home,
              (route) => false,
            );
          } else if (state is auth.AuthUnauthenticated) {
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              AppRoutes.login,
              (route) => false,
            );
          }
        },
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'TravelSpot',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,

          // Configuração de localização
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('pt'), // Portuguese
          ],
          locale: const Locale('pt'), // Definir português como padrão

          initialRoute: '/',
          routes: {
            '/': (context) => const AuthNavigator(),
            ...AppRoutes.routes,
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    // O BlocListener foi movido para o TravelSpotApp para ser global.
    // Este widget agora serve apenas como uma tela de carregamento inicial.
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Verificando autenticação...'),
          ],
        ),
      ),
    );
  }
}
