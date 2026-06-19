import 'package:flutter/material.dart';
import '../models/premium_feature.dart';

class PremiumProvider extends ChangeNotifier {
  bool _isPremium = false;
  final Set<PremiumFeature> _unlockedFeatures = {
    PremiumFeature.export4K,
    PremiumFeature.allEffects,
    PremiumFeature.noAds,
    PremiumFeature.aiGeneration,
    PremiumFeature.gifExport,
    PremiumFeature.mp4Export,
  };

  bool get isPremium => _isPremium;
  Set<PremiumFeature> get unlockedFeatures => Set.unmodifiable(_unlockedFeatures);

  bool hasFeature(PremiumFeature feature) {
    return _isPremium || _unlockedFeatures.contains(feature);
  }

  void unlockPremium() {
    _isPremium = true;
    notifyListeners();
  }

  void unlockFeature(PremiumFeature feature) {
    _unlockedFeatures.add(feature);
    notifyListeners();
  }

  List<PremiumFeature> get lockedFeatures {
    if (_isPremium) return [];
    return PremiumFeature.values
        .where((f) => !_unlockedFeatures.contains(f))
        .toList();
  }
}
