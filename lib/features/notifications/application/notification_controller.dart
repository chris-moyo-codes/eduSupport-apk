import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_controller.dart';
import '../data/notification_data.dart';

export '../data/notification_data.dart';

class NotificationController extends StateNotifier<List<EduNotification>> {
  NotificationController(EduRole role)
    : super(getNotificationsForRole(role));

  int get unreadCount => state.where((n) => !n.isRead).length;

  void markRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id)
          EduNotification(
            id: n.id,
            title: n.title,
            body: n.body,
            timeAgo: n.timeAgo,
            icon: n.icon,
            isRead: true,
          )
        else
          n,
    ];
  }

  void markAllRead() {
    state = [
      for (final n in state)
        EduNotification(
          id: n.id,
          title: n.title,
          body: n.body,
          timeAgo: n.timeAgo,
          icon: n.icon,
          isRead: true,
        ),
    ];
  }
}

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, List<EduNotification>>((ref) {
      final role = ref.watch(
        authControllerProvider.select((s) => s.role),
      );
      return NotificationController(role);
    });

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(
    notificationControllerProvider.select(
      (list) => list.where((n) => !n.isRead).length,
    ),
  );
});
