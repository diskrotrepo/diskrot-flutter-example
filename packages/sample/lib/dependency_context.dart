import 'package:get_it/get_it.dart';
import 'package:sample/auth/auth_repository.dart';
import 'package:sample/configuration/configuration.dart';
import 'package:sample/http/http_client.dart';
import 'package:sample/logger/logger.dart';

final di = GetIt.I;
final logger = Logger();

Future<void> dependencySetup() async {
  di.registerSingleton<Configuration>(Configuration.fromEnvironment());
  di.registerSingleton<DiskRotHttpClient>(
      DiskRotHttpClient(di<Configuration>()));
  di.registerSingleton<AuthRepository>(AuthRepository());
}
