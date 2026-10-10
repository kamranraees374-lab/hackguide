import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  AdService._();
  static const String bannerTestId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialTestId = 'ca-app-pub-3940256099942544/1033173712';
  static bool _initialized = false;
  static InterstitialAd? _interstitial;
  static Future<void> initialize() async {
    if (_initialized) return;
    await MobileAds.instance.initialize();
    _initialized = true;
    _loadInterstitial();
  }
  static void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialTestId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (error) => _interstitial = null,
      ),
    );
  }
  /// Module index is zero-based. Ads are allowed only in modules 2–8.
  static Future<void> showInterstitialIfAllowed(int moduleIndex) async {
    if (moduleIndex < 1 || moduleIndex > 7) return;
    final ad = _interstitial;
    _interstitial = null;
    if (ad != null) {
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) { ad.dispose(); _loadInterstitial(); },
        onAdFailedToShowFullScreenContent: (ad, error) { ad.dispose(); _loadInterstitial(); },
      );
      await ad.show();
    } else {
      _loadInterstitial();
    }
  }
}

class AdBannerForModule extends StatefulWidget {
  final int moduleIndex;
  const AdBannerForModule({super.key, required this.moduleIndex});
  @override
  State<AdBannerForModule> createState() => _AdBannerForModuleState();
}
class _AdBannerForModuleState extends State<AdBannerForModule> {
  BannerAd? _banner;
  bool _loaded = false;
  @override
  void initState() {
    super.initState();
    if (widget.moduleIndex >= 1 && widget.moduleIndex <= 7) {
      _banner = BannerAd(
        adUnitId: AdService.bannerTestId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) { if (mounted) setState(() => _loaded = true); },
          onAdFailedToLoad: (ad, error) { ad.dispose(); },
        ),
      )..load();
    }
  }
  @override
  void didUpdateWidget(covariant AdBannerForModule oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.moduleIndex != widget.moduleIndex) {
      _banner?.dispose();
      _banner = null;
      _loaded = false;
      if (widget.moduleIndex >= 1 && widget.moduleIndex <= 7) {
        _banner = BannerAd(adUnitId: AdService.bannerTestId, size: AdSize.banner,
          request: const AdRequest(),
          listener: BannerAdListener(
            onAdLoaded: (_) { if (mounted) setState(() => _loaded = true); },
            onAdFailedToLoad: (ad, error) => ad.dispose(),
          ))..load();
      }
    }
  }
  @override
  void dispose() { _banner?.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    if (widget.moduleIndex < 1 || widget.moduleIndex > 7 || !_loaded || _banner == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(width: _banner!.size.width.toDouble(),
      height: _banner!.size.height.toDouble(),
      child: AdWidget(ad: _banner!));
  }
}

