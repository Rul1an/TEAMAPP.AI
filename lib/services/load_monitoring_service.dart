import 'package:flutter/material.dart';

import '../models/annual_planning/morphocycle.dart';

/// Utility helpers for the Load Monitoring module.
///
/// Contains *pure* functions – there is **no** dependency on Riverpod/
/// Flutter widgets so this service can be easily unit-tested.
class LoadMonitoringService {
  // -------------------- Summary metrics -------------------- //

  static double getCurrentLoad(List<Morphocycle> cycles) =>
      cycles.isNotEmpty ? cycles.last.weeklyLoad : 0.0;

  static double getAverageLoad(List<Morphocycle> cycles) {
    if (cycles.isEmpty) return 0.0;
    final sum = cycles.fold<double>(0.0, (t, m) => t + m.weeklyLoad);
    return sum / cycles.length;
  }

  static double getPeakLoad(List<Morphocycle> cycles) => cycles.fold<double>(
    0.0,
    (max, m) => m.weeklyLoad > max ? m.weeklyLoad : max,
  );

  static double getCurrentAcr(List<Morphocycle> cycles) =>
      cycles.isNotEmpty ? cycles.last.acuteChronicRatio : 1.0;

  // -------------------- Color helpers -------------------- //
  static Color loadColor(double load) {
    if (load < 1000) return Colors.green;
    if (load < 1500) return Colors.orange;
    if (load < 2000) return Colors.red;
    return Colors.purple;
  }

  static Color acrColor(double acr) {
    if (acr >= 0.8 && acr <= 1.3) return Colors.green;
    if (acr < 0.8 || acr <= 1.5) return Colors.orange;
    return Colors.red;
  }

  static Color intensityColor(String intensity) {
    switch (intensity.toLowerCase()) {
      case 'recovery':
        return Colors.green;
      case 'activation':
        return Colors.blue;
      case 'development':
        return Colors.orange;
      case 'acquisition':
        return Colors.red;
      case 'competition':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Injury-risk helpers
  static Color riskColor(InjuryRisk risk) {
    switch (risk) {
      case InjuryRisk.underloaded:
        return Colors.blue;
      case InjuryRisk.optimal:
        return Colors.green;
      case InjuryRisk.high:
        return Colors.red;
      case InjuryRisk.extreme:
        return Colors.purple;
    }
  }

  static IconData riskIcon(InjuryRisk risk) {
    switch (risk) {
      case InjuryRisk.underloaded:
        return Icons.trending_down;
      case InjuryRisk.optimal:
        return Icons.check_circle;
      case InjuryRisk.high:
        return Icons.warning;
      case InjuryRisk.extreme:
        return Icons.dangerous;
    }
  }

  // Load-zone helpers based on descriptive string
  static Color loadZoneColor(String zone) {
    if (zone.contains('Recovery')) return Colors.green;
    if (zone.contains('Optimal')) return Colors.blue;
    if (zone.contains('High Load')) return Colors.orange;
    if (zone.contains('Danger')) return Colors.red;
    return Colors.grey;
  }

  // Acute:Chronic Workload Ratio helpers
  static Color acwrColor(double acwr) {
    if (acwr >= 0.8 && acwr <= 1.3) return Colors.green;
    if (acwr < 0.8 || acwr <= 1.5) return Colors.orange;
    return Colors.red;
  }

  static IconData acwRIcon(double acwr) {
    if (acwr < 0.8) return Icons.trending_down;
    if (acwr > 1.5) return Icons.dangerous;
    if (acwr > 1.3) return Icons.warning;
    return Icons.check_circle;
  }
}
