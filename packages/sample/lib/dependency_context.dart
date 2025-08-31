import 'package:get_it/get_it.dart';
import 'package:sample/auth/auth_repository.dart';
import 'package:sample/configuration/configuration.dart';
import 'package:sample/http/http_client.dart';
import 'package:sample/logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final di = GetIt.I;
final logger = Logger();

Future<void> dependencySetup() async {
  SharedPreferences.setPrefix('');

  di.registerSingleton<Configuration>(Configuration.fromEnvironment());
  di.registerSingleton<DiskRotHttpClient>(
      DiskRotHttpClient(di<Configuration>().apiHost));
  di.registerSingleton<AuthRepository>(
      AuthRepository(baseUrl: di<Configuration>().apiHost));
}
