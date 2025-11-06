import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/notifications/local/notification.dart';
import '../../../../core/services/api/service.dart';
import '../../data/models/notification_model.dart';

part 'notification_provider.g.dart';

class NotificationState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? error;

  NotificationState({
    required this.notifications,
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.error,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }
}

@riverpod
class NotificationList extends _$NotificationList {
  final Logger _logger = Logger(
    printer: SimplePrinter(
      colors: false,
      printTime: false,
    ),
  );

  @override
  NotificationState build() {
    return NotificationState(notifications: []);
  }

  Future<void> loadNotifications() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final webService = ref.read(webServiceProvider);
      final response = await webService.getNotifications(state.currentPage);

      if (response.success) {
        final newNotifications = state.currentPage == 0 ? response.data : [...state.notifications, ...response.data];

        state = state.copyWith(
          notifications: newNotifications,
          isLoading: false,
          hasMore: response.data.length >= 20,
          currentPage: state.currentPage + 1,
        );

        _logger.i('Loaded ${response.data.length} notifications (page ${state.currentPage - 1})');
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load notifications',
        );
      }
    } catch (e, stackTrace) {
      _logger.e('Error loading notifications', error: e, stackTrace: stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    _logger.i('Refreshing notifications');
    state = NotificationState(notifications: []);
    await loadNotifications();
    ref.invalidate(unreadCountProvider);
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final webService = ref.read(webServiceProvider);
      final success = await webService.markNotificationAsRead(notificationId);

      if (success) {
        final updatedNotifications = state.notifications.map((notification) {
          if (notification.id == notificationId) {
            return notification.copyWith(isRead: true, readAt: DateTime.now());
          }
          return notification;
        }).toList();

        state = state.copyWith(notifications: updatedNotifications);
        ref.invalidate(unreadCountProvider);

        _logger.i('Marked notification $notificationId as read');
      }
    } catch (e, stackTrace) {
      _logger.e('Error marking notification as read', error: e, stackTrace: stackTrace);
    }
  }
}

@riverpod
Future<int> unreadCount(Ref ref) async {
  try {
    final webService = ref.read(webServiceProvider);
    final response = await webService.getUnreadCount();
    final count = response.unreadCount;

    // Update iOS app badge with the count from API
    LocalNoticeService().updateAppBadge(count);

    return count;
  } catch (e) {
    return 0;
  }
}
