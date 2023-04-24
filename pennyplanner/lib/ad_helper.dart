import 'dart:io';

//Loads google test unit banner ad
class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

//Loads google test unit fullscreen ad
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/7049598008';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
