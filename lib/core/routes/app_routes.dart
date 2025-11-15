import 'package:flutter/material.dart';
import '../../feature/auth/presentation/page/login_page.dart';
import '../../feature/auth/presentation/page/register_page.dart';
import '../../feature/places/presentation/page/places_list_page.dart';
import '../../feature/places/presentation/page/add_place_page.dart';
import '../../feature/places/domain/entity/place.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String places = '/places';
  static const String addPlace = '/add-place';
  static const String placeDetail = '/place-detail';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      home: (context) =>
          const PlacesListPage(), // Home aponta para Places por enquanto
      places: (context) => const PlacesListPage(),
      addPlace: (context) => const AddPlacePage(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case placeDetail:
        final place = settings.arguments as Place?;
        if (place != null) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text(place.name)),
              body: Center(child: Text('Place Detail: ${place.name}')),
            ),
            settings: settings,
          );
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: const Center(
          child: Text('Página não encontrada'),
        ),
      ),
    );
  }

  static void pushNamed(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void pushReplacementNamed(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void pushNamedAndRemoveUntil(
      BuildContext context, String routeName, RoutePredicate predicate,
      {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, predicate,
        arguments: arguments);
  }

  static void pop(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }
}
