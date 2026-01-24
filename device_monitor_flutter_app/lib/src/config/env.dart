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
}