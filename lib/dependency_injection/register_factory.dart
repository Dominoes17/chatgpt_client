import 'package:get_it/get_it.dart';
import 'package:hecticai/logic/bloc.dart';

//declare global variable to access dependencies
final sl = GetIt.instance;

class RegisterFactory {
  //function called at startup to register dependencies. Lazy singletons used for BLoCs as we want all listeners to have the same instance in this case.
  void setup() {
    sl.registerLazySingleton<ProductBloc>(() => ProductBloc());
  }
}
