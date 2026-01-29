import 'package:flutter/material.dart';
import 'package:gma_mediation_unity/gma_mediation_unity.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final ConsentManager consenting = ConsentManager();

class ConsentManager with ChangeNotifier {
  ConsentStatus? status;

  bool get hasConsent =>
      status == ConsentStatus.obtained || status == ConsentStatus.notRequired;

  ConsentManager() {
    _initializeConsent();
  }

  Future<void> _initializeConsent() async {
    // ----------- UMP -----------
    status = await ConsentInformation.instance.getConsentStatus();
    notifyListeners();

    if (status == ConsentStatus.required) {
      updateConsent();
    } else {
      _applyConsentToSdks();
    }
  }

  void updateConsent() {
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          _loadForm();
        }
      },
      (error) => debugPrint("Consent update error: $error"),
    );
  }

  void _loadForm() {
    ConsentForm.loadConsentForm((form) async {
      status = await ConsentInformation.instance.getConsentStatus();
      notifyListeners();

      if (status == ConsentStatus.required) {
        form.show((_) => _loadForm());
      } else {
        _applyConsentToSdks();
      }
    }, (error) => debugPrint("Consent form load error: $error"));
  }

  void _applyConsentToSdks() {
    // ---- Unity GDPR / CCPA ----
    GmaMediationUnity().setGDPRConsent(hasConsent);
    GmaMediationUnity().setCCPAConsent(hasConsent);
  }
}
