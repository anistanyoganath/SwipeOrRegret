import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:swipeorregret/core/utils/ads/ad_ids.dart';
import 'package:swipeorregret/core/utils/ads/request_ads.dart';

class BannerAdvert extends StatefulWidget {
  const BannerAdvert({super.key});

  @override
  State<BannerAdvert> createState() => _BannerAdvertState();
}

class _BannerAdvertState extends State<BannerAdvert> {
  BannerAd? _bannerAd;

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: AdIds.bannerAdId,
      request: requestAd(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return _bannerAd != null
        ? SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        : const SizedBox();
  }
}
