import 'package:onmitrix/config/env_config.dart';
import 'package:onmitrix/services/api/api_client.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  late final EnvConfig _envConfig;

  factory AppConfig() {
    return _instance;
  }

  AppConfig._internal();

  Future<void> initialize({Environment environment = Environment.dev}) async {
    _envConfig = EnvConfig.fromEnvironment(environment);
    
    // Initialize API client
    ApiClient().initialize(_envConfig);
  }

  EnvConfig get envConfig => _envConfig;
}