class ApplicationConfig {
  String appName;
  String path;
  List<ApiConfig> api;

  ApplicationConfig({required this.appName, required this.path, required this.api});
}

class ApiConfig {
  String key;
  String path;

  ApiConfig({required this.key, required this.path});
}
