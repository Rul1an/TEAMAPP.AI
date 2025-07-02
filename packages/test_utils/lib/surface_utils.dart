/// Utilities for configuring the virtual device viewport in widget & integration tests.
///
/// These helpers wrap the new multi-window–safe APIs introduced in Flutter 3.10+
/// (`WidgetTester.view` / `platformDispatcher`) so that tests stay compatible
/// when the old `window.*TestValue` methods are removed (Flutter 4.0).
library surface_utils;

import 'dart:ui' as ui show Size;

import 'package:flutter_test/flutter_test.dart';

/// Sets the surface size and device pixel ratio for the next frames.
/// Always pair with [resetScreenSize].
void setScreenSize(WidgetTester tester, ui.Size size, {double pixelRatio = 1.0}) {
  final view = tester.view;
  view.physicalSize = size;
  view.devicePixelRatio = pixelRatio;
  // Pump to apply changes.
  tester.binding.handleMetricsChanged();
}

/// Resets the surface size & DPR to their defaults.
void resetScreenSize(WidgetTester tester) {
  final view = tester.view;
  view.resetPhysicalSize();
  view.resetDevicePixelRatio();
  tester.binding.handleMetricsChanged();
}

/// Use this overload in setup functions where no [WidgetTester] is available yet.
void setScreenSizeBinding(TestWidgetsFlutterBinding binding, ui.Size size,
    {double pixelRatio = 1.0}) {
  binding.window.physicalSizeTestValue = size;
  binding.window.devicePixelRatioTestValue = pixelRatio;
}

void resetScreenSizeBinding(TestWidgetsFlutterBinding binding) {
  binding.window.clearPhysicalSizeTestValue();
  binding.window.clearDevicePixelRatioTestValue();
}
