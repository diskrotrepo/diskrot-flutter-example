Configuration? _configuration;

Configuration get configuration {
  _configuration ??= Configuration.fromEnvironment();
  return _configuration!;
}

class Configuration {
  const Configuration({
    required this.buildEnvironment,
    required this.apiHost,
    required this.loginUri,
    required this.secure,
    required this.applicationId,
    required this.redirectUri,
  });

  factory Configuration.fromEnvironment() {
    final buildEnv = environmentLookup();
    final env = switch (buildEnv) {
      'local' => BuildEnvironment.local,
      'prod' => BuildEnvironment.prod,
      _ => throw ArgumentError('Unknown build environment: $buildEnv'),
    };

    return Configuration(
      buildEnvironment: env,
      applicationId: switch (env) {
        BuildEnvironment.local => '1ce7757e-3c3a-42a9-8fa7-ec6923166b1b',
        BuildEnvironment.prod => '1ce7757e-3c3a-42a9-8fa7-ec6923166b1b',
      },
      redirectUri: switch (env) {
        BuildEnvironment.local => 'http://localhost:8090/oauth/callback',
        BuildEnvironment.prod => 'https://demo.diskrot.com/oauth/callback',
      },
      secure: switch (env) {
        BuildEnvironment.local => false,
        BuildEnvironment.prod => true,
      },
      apiHost: switch (env) {
        BuildEnvironment.local => 'localhost',
        BuildEnvironment.prod => 'api.diskrot.com',
      },
      loginUri: switch (env) {
        BuildEnvironment.local => 'localhost:8081',
        BuildEnvironment.prod => 'login.diskrot.com',
      },
    );
  }

  final BuildEnvironment buildEnvironment;
  final String apiHost;
  final String loginUri;
  final bool secure;
  final String applicationId;
  final String redirectUri;

  static environmentLookup() {
    bool inDebug = false;
    assert(() {
      inDebug = true;
      return true;
    }());

    if (inDebug) {
      return 'local';
    } else {
      return 'prod';
    }
  }
}

enum BuildEnvironment { local, prod }
