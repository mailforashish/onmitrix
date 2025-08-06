enum Environment {
  dev,
  staging,
  prod,
}

class EnvConfig {
  final String apiBaseUrl;
  final String apiKey;
  final bool enableLogging;

  EnvConfig({
    required this.apiBaseUrl,
    required this.apiKey,
    required this.enableLogging,
  });

  factory EnvConfig.fromEnvironment(Environment env) {
    switch (env) {
      case Environment.dev:
        return EnvConfig(
          apiBaseUrl: 'http://localhost:8080/api',
          apiKey: 'dev_api_key',
          enableLogging: true,
        );
      case Environment.staging:
        return EnvConfig(
          apiBaseUrl: 'https://staging-api.onmitrix.com/api',
          apiKey: 'staging_api_key',
          enableLogging: true,
        );
      case Environment.prod:
        return EnvConfig(
          apiBaseUrl: 'https://api.onmitrix.com/api',
          apiKey: 'prod_api_key',
          enableLogging: false,
        );
    }
  }
}