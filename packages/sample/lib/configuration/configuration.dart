Configuration? _configuration;

Configuration get configuration {
  _configuration ??= Configuration.fromEnvironment();
  return _configuration!;
}

class Configuration {
  const Configuration(
      {required this.buildEnvironment,
      required this.apiHost,
      required this.apiKey});

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
      apiHost: switch (env) {
        BuildEnvironment.local => 'https://api.diskrot.com/v1',
        BuildEnvironment.prod => 'https://api.diskrot.com/v1',
      },
    );
  }

  final BuildEnvironment buildEnvironment;
  final String apiHost;
  final String apiKey;

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
