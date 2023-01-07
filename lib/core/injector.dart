import 'package:get_it/get_it.dart';
import 'package:template_app/modules/login/bloc/login_bloc.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  injector.registerSingleton<LoginBloc>(LoginBloc());
}