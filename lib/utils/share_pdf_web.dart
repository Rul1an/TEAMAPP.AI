// ignore_for_file: avoid_web_libraries_in_flutter
// A thin wrapper that re-exports the needed classes from `dart:html` for
// conditional imports in `share_pdf_utils.dart`.

library share_pdf_web;

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

typedef Blob = html.Blob;
typedef Url = html.Url;
typedef AnchorElement = html.AnchorElement;