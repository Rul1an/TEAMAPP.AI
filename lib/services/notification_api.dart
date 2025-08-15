abstract class NotificationApi {
  Future<void> init();
  Future<void> requestPermission();

  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);

  Future<void> subscribeToTenant(String tenantId);
  Future<void> unsubscribeFromTenant(String tenantId);

  Future<void> subscribeToUser(String userId);
  Future<void> unsubscribeFromUser(String userId);
}
