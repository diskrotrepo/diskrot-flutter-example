Configuration? _configuration;

Configuration get configuration {
  _configuration ??= Configuration.fromEnvironment();
  return _configuration!;
}

class Configuration {
  const Configuration({
    required this.buildEnvironment,
    required this.apiHost,
    required this.apiKey,
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
      apiKey: 'diskrot_RtKcS9ve8MGYg8vNtJbzBSYnySU1yq6uAt66XZ70GiI',
      applicationId: switch (env) {
        BuildEnvironment.local => '1ce7757e-3c3a-42a9-8fa7-ec6923166b1b',
        BuildEnvironment.prod => '1ce7757e-3c3a-42a9-8fa7-ec6923166b1b',
      },
      redirectUri: switch (env) {
        BuildEnvironment.local => 'localhost:8090',
        BuildEnvironment.prod => 'localhost:8090',
      },
      secure: switch (env) {
        BuildEnvironment.local => false,
        BuildEnvironment.prod => true,
      },
      apiHost: switch (env) {
        BuildEnvironment.local => 'https://api.diskrot.com/v1',
        BuildEnvironment.prod => 'https://api.diskrot.com/v1',
      },
      loginUri: switch (env) {
        BuildEnvironment.local => 'localhost:8081',
        BuildEnvironment.prod => 'login.diskrot.com',
      },
    );
  }

  final BuildEnvironment buildEnvironment;
  final String apiHost;
  final String apiKey;
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
