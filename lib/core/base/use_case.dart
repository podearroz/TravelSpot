import '../functional/try.dart';

abstract class UseCase<T, P> {
  Future<Try<T>> call(P params);
}

abstract class UnitUseCase<T> {
  Future<Try<T>> call();
}
