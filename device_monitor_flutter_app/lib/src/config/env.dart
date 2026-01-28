enum EEnvType{
  dev,
  prod,
  staging,
  qa,
  uat,
}

class Env{
  static String baseUrl = '';
  static EEnvType type = EEnvType.dev;
  static String X_API_KEY = '';
  static String X_SERVICE_NAME = '';
}