import 'dart:io';

class ConnectivityHelper{
  //Best approach - Try multiple hosts for redundancy
  static Future<bool> hasInternetConnection() async {
    final hosts = [
      'google.com',
      'cloudflare.com',
    ];

    for (final host in hosts) {
      try {
        final result = await InternetAddress.lookup(host)
            .timeout(const Duration(seconds: 3));

        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } catch (e) {
        // Try next host
        continue;
      }
    }

    return false;
  }
}