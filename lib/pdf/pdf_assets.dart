/// Centralised asset paths & helpers used by PDF generators.
///
/// Keeping them in one file avoids magic strings scattered across generators
/// and allows easy swapping of logos/fonts in white-label editions.
class PdfAssets {
  PdfAssets._();

  static const String logoPath = 'assets/pdf/logo.png';
  static const String fontRegular = 'assets/pdf/opensans_regular.ttf';
  static const String fontBold = 'assets/pdf/opensans_bold.ttf';
}
