import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/auth/domain/entity/user.dart';

abstract class AuthRepository {
  Future<Try<User>> login(String email, String password);
  Future<Try<User>> register(String email, String password, String name);
  Future<Try<void>> logout();
  Future<Try<User?>> getCurrentUser();
}
