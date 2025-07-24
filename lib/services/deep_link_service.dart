// ignore_for_file: flutter_style_todos
class DeepLinkService {
  static final DeepLinkService instance = DeepLinkService();

  Future<void> init(dynamic router) async {
    // TODO(team): setup deep link handling using GoRouter instance.
  }

  /// Returns a shareable deep link for a match.
  Uri createMatchLink(String matchId) {
    // In production we would generate a Firebase Dynamic Link or similar.
    // For now construct app web baseUrl + hash route.
    const base = 'https://teamappai.netlify.app';
    return Uri.parse('$base/#/matches/$matchId');
  }

  /// Returns a shareable deep link for a training session.
  Uri createTrainingLink(String trainingId) {
    const base = 'https://teamappai.netlify.app';
    return Uri.parse('$base/#/training/$trainingId');
  }
}
