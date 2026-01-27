
abstract class ICacheRepository{
  Future<void> saveToken(String token);
  String? fetchToken();
  Future<void>? saveCurrentUserId(int? id);
  int? fetchCurrentUserId();
  String? fetchDeviceEntityJson();
  Future<void> saveDeviceEntityJson(String encodedJson);
  void logout();
}