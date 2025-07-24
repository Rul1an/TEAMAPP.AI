// ignore_for_file: flutter_style_todos
class NotificationService {
  static final NotificationService instance = NotificationService();

  Future<void> init() async {
    // TODO: integrate Firebase Messaging or local notifications.
  }

  Future<void> requestPermission() async {}

  Future<void> subscribeToTopic(String topic) async {}
}
