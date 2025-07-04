/// PDF generator infrastructure.
///
/// Defines an abstract [PdfGenerator] base class that concrete generators can
/// implement to produce PDF bytes for a given input type.
/// This keeps each generator small and unit-testable.
///
/// All generators return a Uint8List with the PDF bytes.
import 'dart:typed_data';
import 'core/font_cache.dart';

// ignore_for_file: dangling_library_doc_comments

/// Base contract for PDF generators.
///
/// Implementations are expected to produce a [Uint8List] containing the
/// bytes of a ready-to-print PDF document. The generator must be pure and
/// side-effect-free: it cannot perform IO (saving to disk or sharing). Those
/// concerns live in the calling layer (e.g. provider or service).
///
/// Generators should be lightweight and thus can be instantiated per request.
/// Heavy resources (fonts, images) should be cached internally where needed.
abstract class PdfGenerator<T> {
  const PdfGenerator();

  /// Builds a PDF based on [data]. Implementations may throw if the provided
  /// data cannot be rendered.
  Future<Uint8List> generate(T data);

  // Protected helper for subclasses
  FontCache get fonts => FontCache.instance;
}

// Base class for PDF generators so we can add new ones independently
// of a monolithic PdfService implementation.
//
// All generators return a Uint8List with the PDF bytes.
