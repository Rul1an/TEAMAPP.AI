import 'package:flutter/foundation.dart';

/// Subscription Provider
/// Manages subscription state and tier information
class SubscriptionProvider extends ChangeNotifier {
  SubscriptionTier _currentTier = SubscriptionTier.pro;
  bool _isLoading = false;
  String? _error;

  // Getters
  SubscriptionTier get currentTier => _currentTier;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // For demo purposes, we'll use Pro tier
  void setTier(SubscriptionTier tier) {
    _currentTier = tier;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }
}

enum SubscriptionTier {
  basic(0, 'Basic'),
  pro(1, 'Pro'),
  enterprise(2, 'Enterprise');

  const SubscriptionTier(this.value, this.displayName);

  final int value;
  final String displayName;
}
