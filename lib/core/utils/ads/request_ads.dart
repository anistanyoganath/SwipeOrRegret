import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:swipeorregret/core/utils/ads/ad_consent.dart';

AdRequest requestAd() {
  AdRequest adRequest;

  if (consenting.status == ConsentStatus.obtained) {
    // Personalized ads
    adRequest = const AdRequest();
  } else if (consenting.status == ConsentStatus.notRequired) {
    // Not required to show consent form, treat as consent obtained
    adRequest = const AdRequest();
  } else {
    // Non-personalized ads
    adRequest = const AdRequest(
      extras: {
        'npa': '1', // Non-personalized ads request
      },
    );
  }

  return adRequest;
}
