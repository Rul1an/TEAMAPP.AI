// Web implementation using JS interop with beforeinstallprompt

// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:js_interop';
import 'package:js/js_util.dart' as js_util;

JSObject? _deferredPrompt;

@JS('window')
external JSAny get _window;

Future<bool> isPwaInstallAvailable() async {
  try {
    final w = _window as JSObject;
    final has = js_util.hasProperty(w, 'deferredPwaPrompt');
    return has || _deferredPrompt != null;
  } catch (_) {
    return false;
  }
}

Future<bool> triggerPwaInstall() async {
  try {
    if (_deferredPrompt != null) {
      final obj = _deferredPrompt!;
      if (js_util.hasProperty(obj, 'prompt')) {
        js_util.callMethod<dynamic>(obj, 'prompt', const <dynamic>[]);
        return true;
      }
    }
    // Fallback: try global stored prompt
    final w = _window as JSObject;
    if (js_util.hasProperty(w, 'deferredPwaPrompt')) {
      final p = js_util.getProperty<dynamic>(w, 'deferredPwaPrompt');
      if (p is JSObject && js_util.hasProperty(p, 'prompt')) {
        js_util.callMethod<dynamic>(p, 'prompt', const <dynamic>[]);
        return true;
      }
    }
    return false;
  } catch (_) {
    return false;
  }
}

// Attach a listener once to capture the beforeinstallprompt event
void _attachListenerOnce() {
  try {
    final w = _window as JSObject;
    if (js_util.hasProperty(w, '__pwa_listener_attached')) return;
    final listener = (JSAny e) {
      // e.preventDefault()
      if (e is JSObject && js_util.hasProperty(e, 'preventDefault')) {
        js_util.callMethod<dynamic>(e, 'preventDefault', const <dynamic>[]);
      }
      _deferredPrompt = e as JSObject?;
      js_util.setProperty(w, 'deferredPwaPrompt', e);
    }.toJS;
    js_util.callMethod<dynamic>(w, 'addEventListener', <dynamic>[
      'beforeinstallprompt',
      listener,
    ]);
    js_util.setProperty(w, '__pwa_listener_attached', true);
  } catch (_) {}
}

// Ensure listener is registered at import time
void ensurePwaInstallSupport() => _attachListenerOnce();
