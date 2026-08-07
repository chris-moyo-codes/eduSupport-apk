import '../../auth/application/auth_controller.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

enum EduNotificationIcon {
  calendar,
  message,
  download,
  quiz,
  clock,
  users,
  report,
  trending,
  person,
  workspacePremium,
  info,
}

enum EduNotificationCategory {
  system,
  premium,
  sessionUpdate,
  academic,
  communication,
  admin,
}

class EduNotification {
  EduNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.icon,
    this.category = EduNotificationCategory.system,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final EduNotificationIcon icon;
  final EduNotificationCategory category;
  bool isRead;
}

// ─── Mock Data (mirrors web's notifications.ts) ───────────────────────────────

List<EduNotification> _studentNotifications() => [
  EduNotification(
    id: 's_prem1',
    title: 'Welcome to EduSupport Premium!',
    body: 'Your subscription is active. You now have unlimited access to all resources and priority support.',
    timeAgo: '10 min ago',
    icon: EduNotificationIcon.workspacePremium,
    category: EduNotificationCategory.premium,
  ),
  EduNotification(
    id: 's1',
    title: 'Session confirmed for tomorrow',
    body: 'Your session with Dr. Amara Nkosi is at 10:00 AM. Check your calendar.',
    timeAgo: '30 min ago',
    icon: EduNotificationIcon.calendar,
    category: EduNotificationCategory.sessionUpdate,
  ),
  EduNotification(
    id: 's2',
    title: 'New feedback from your tutor',
    body: 'Dr. Nkosi left comments on your Biology essay submission.',
    timeAgo: '2 hrs ago',
    icon: EduNotificationIcon.message,
    category: EduNotificationCategory.academic,
  ),
  EduNotification(
    id: 's_sys1',
    title: 'App updated to version 2.4',
    body: 'Check out the new Premium features and performance improvements.',
    timeAgo: 'Yesterday',
    icon: EduNotificationIcon.info,
    category: EduNotificationCategory.system,
    isRead: true,
  ),
  EduNotification(
    id: 's3',
    title: 'Quiz ready — Cell Structure',
    body: 'A new practice quiz is available for Chapter 4 of your Biology course.',
    timeAgo: 'Yesterday',
    icon: EduNotificationIcon.quiz,
    category: EduNotificationCategory.academic,
    isRead: true,
  ),
  EduNotification(
    id: 's4',
    title: 'Download complete',
    body: 'Mathematics Grade 10 textbook is now saved for offline use.',
    timeAgo: '2 days ago',
    icon: EduNotificationIcon.download,
    category: EduNotificationCategory.system,
    isRead: true,
  ),
];

List<EduNotification> _tutorNotifications() => [
  EduNotification(
    id: 't1',
    title: 'New session booking',
    body: 'Jonathan Doe has booked a session for Thursday at 14:00.',
    timeAgo: '1 hr ago',
    icon: EduNotificationIcon.calendar,
  ),
  EduNotification(
    id: 't2',
    title: 'Student inquiry',
    body: 'Grace Banda is requesting support in Mathematics.',
    timeAgo: '3 hrs ago',
    icon: EduNotificationIcon.message,
  ),
  EduNotification(
    id: 't3',
    title: '3 practice papers submitted',
    body: 'Three students submitted papers and are waiting for your feedback.',
    timeAgo: 'Yesterday',
    icon: EduNotificationIcon.report,
    isRead: true,
  ),
  EduNotification(
    id: 't4',
    title: 'Resource gaining traction',
    body: "Your 'Algebra Basics' resource was downloaded 12 times this week.",
    timeAgo: '2 days ago',
    icon: EduNotificationIcon.trending,
    isRead: true,
  ),
];

List<EduNotification> _adminNotifications() => [
  EduNotification(
    id: 'a1',
    title: '5 registrations pending approval',
    body: 'Five new student accounts are awaiting your review before activation.',
    timeAgo: '15 min ago',
    icon: EduNotificationIcon.users,
  ),
  EduNotification(
    id: 'a2',
    title: 'New tutor application',
    body: 'Dr. James Phiri has submitted an application to join as a verified tutor.',
    timeAgo: '2 hrs ago',
    icon: EduNotificationIcon.person,
  ),
  EduNotification(
    id: 'a3',
    title: 'Storage at 78% capacity',
    body: 'Platform storage is approaching the threshold. Consider archiving older content.',
    timeAgo: '6 hrs ago',
    icon: EduNotificationIcon.report,
    isRead: true,
  ),
  EduNotification(
    id: 'a4',
    title: 'Weekly usage report ready',
    body: 'The platform activity report for this week is available in Analytics.',
    timeAgo: 'Yesterday',
    icon: EduNotificationIcon.report,
    isRead: true,
  ),
];

List<EduNotification> getNotificationsForRole(EduRole role) {
  switch (role) {
    case EduRole.admin:
      return _adminNotifications();
    case EduRole.tutor:
      return _tutorNotifications();
    case EduRole.student:
      return _studentNotifications();
  }
}
