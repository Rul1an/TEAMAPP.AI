/// PDF generator infrastructure.
///
/// Defines an abstract [PdfGenerator] base class that concrete generators can
/// implement to produce PDF bytes for a given input type.
/// This keeps each generator small and unit-testable.
///
/// All generators return a Uint8List with the PDF bytes.
import 'dart:typed_data';

// ignore_for_file: dangling_library_doc_comments

abstract class PdfGenerator<T> {
  const PdfGenerator();

  Future<Uint8List> generate(T input);
}

// Base class for PDF generators so we can add new ones independently
// of a monolithic PdfService implementation.
//
// All generators return a Uint8List with the PDF bytes.
