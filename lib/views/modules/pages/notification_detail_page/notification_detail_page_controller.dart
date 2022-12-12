abstract class NotificationDetailPageController {
  /// Like count of current session
  int get currentLikedCount;
  bool get isLoadingLikedCount;

  /// Like status in current session
  bool get currentHasLiked;

  Future<void> decodeScanCode();
  Future<void> toggleLikeNotification();
  Future<void> shareNotification();
  Future<void> deleteNotification();
}
