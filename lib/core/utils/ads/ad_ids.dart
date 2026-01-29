import 'dart:io';
import 'package:flutter/foundation.dart';

class AdIds {
  // -------------------------------
  // ✅ Rewarded Ads
  // -------------------------------
  static const String rewardedTestAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/5224354917';
  static const String rewardedTestAdUnitIdIOS =
      'ca-app-pub-3940256099942544/1712485313';

  static String get rewardedAdId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? rewardedTestAdUnitIdAndroid
          : 'ca-app-pub-8711818051017729/2043991514';
    } else {
      return kDebugMode
          ? rewardedTestAdUnitIdIOS
          : 'ca-app-pub-8711818051017729/4908594475'; // real ios id
    }
  }

  // -------------------------------
  // ✅ Interstitial Ads
  // -------------------------------
  static const String interstitialTestAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String interstitialTestAdUnitIdIOS =
      'ca-app-pub-3940256099942544/4411468910';

  static String get interstitialAdId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? interstitialTestAdUnitIdAndroid
          : 'ca-app-pub-8711818051017729/7627490689';

      /// real android id
    } else {
      return kDebugMode
          ? interstitialTestAdUnitIdIOS
          : 'ca-app-pub-8711818051017729/4806660304';
    }
  }

  // -------------------------------
  // ✅ Banner Ads
  // -------------------------------
  static const String bannerTestAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String bannerTestAdUnitIdIOS =
      'ca-app-pub-3940256099942544/2934735716';

  static String get bannerAdId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? bannerTestAdUnitIdAndroid
          : 'ca-app-pub-8711818051017729/1114827304';
    } else {
      return kDebugMode
          ? bannerTestAdUnitIdIOS
          : 'ca-app-pub-8711818051017729/1544064535';
    }
  }
}
