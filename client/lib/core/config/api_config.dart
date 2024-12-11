import 'dart:io';

class ApiConfig {
  static String get http {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    } else if (Platform.isIOS) {
      return 'http://localhost:3000';
    } else {
      return 'http://192.168.0.101:3000';
    }
  }

  static String get ws {
    if (Platform.isAndroid) {
      return 'ws://10.0.2.2:3000';
    } else {
      return 'ws://10.0.2.2:3000';
    }
  }
}
