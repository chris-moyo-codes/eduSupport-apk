

enum AlertSeverity { critical, warning, info }

class AdminAlert {
  const AdminAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.time,
    this.isAcknowledged = false,
  });

  final String id;
  final String title;
  final String description;
  final AlertSeverity severity;
  final String time;
  final bool isAcknowledged;

  AdminAlert copyWith({
    String? id,
    String? title,
    String? description,
    AlertSeverity? severity,
    String? time,
    bool? isAcknowledged,
  }) {
    return AdminAlert(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      time: time ?? this.time,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
    );
  }
}

class AdminUser {
  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.joinedDate,
    this.riskLevel,
    this.rating,
  });

  final String id;
  final String name;
  final String email;
  final String role; // 'student' or 'tutor'
  final String status; // 'Active', 'Inactive', 'Pending Review'
  final String joinedDate;
  final String? riskLevel; // For students: Low, Medium, High
  final double? rating; // For tutors

  AdminUser copyWith({
    String? status,
  }) {
    return AdminUser(
      id: id,
      name: name,
      email: email,
      role: role,
      status: status ?? this.status,
      joinedDate: joinedDate,
      riskLevel: riskLevel,
      rating: rating,
    );
  }
}

class PlatformActivity {
  const PlatformActivity({
    required this.id,
    required this.user,
    required this.action,
    required this.time,
    required this.type,
  });

  final String id;
  final String user;
  final String action;
  final String time;
  final String type; // 'upload', 'registration', 'system'
}

final List<AdminAlert> initialAdminAlerts = [
  const AdminAlert(
    id: "al1",
    title: "Tutor Verification Pending",
    description: "3 new tutor applications require manual review.",
    severity: AlertSeverity.warning,
    time: "2 hours ago",
  ),
  const AdminAlert(
    id: "al2",
    title: "Content Report",
    description: "User flagged a biology resource for incorrect answers.",
    severity: AlertSeverity.warning,
    time: "5 hours ago",
  ),
  const AdminAlert(
    id: "al3",
    title: "Sync Service Latency",
    description: "Offline sync service experienced 2s latency spikes.",
    severity: AlertSeverity.info,
    time: "Yesterday",
  ),
];

final List<AdminUser> initialAdminUsers = [
  // Students
  const AdminUser(id: "s1", name: "Sarah Jenkins", email: "sarah.j@example.com", role: "student", status: "Active", joinedDate: "Oct 2023", riskLevel: "Low"),
  const AdminUser(id: "s2", name: "David Osei", email: "david.o@example.com", role: "student", status: "Active", joinedDate: "Jan 2024", riskLevel: "Medium"),
  const AdminUser(id: "s3", name: "Emma Mwangi", email: "emma.m@example.com", role: "student", status: "Inactive", joinedDate: "Mar 2023", riskLevel: "High"),
  // Tutors
  const AdminUser(id: "t1", name: "Dr. Eleanor Vance", email: "eleanor.v@example.com", role: "tutor", status: "Active", joinedDate: "Aug 2023", rating: 4.9),
  const AdminUser(id: "t2", name: "Prof. Arthur Pendelton", email: "arthur.p@example.com", role: "tutor", status: "Active", joinedDate: "Sep 2022", rating: 4.7),
  const AdminUser(id: "t3", name: "Dr. Sarah Chen", email: "sarah.c@example.com", role: "tutor", status: "Pending Review", joinedDate: "Just now", rating: 5.0),
];

final List<PlatformActivity> adminRecentActivity = [
  const PlatformActivity(id: "pa1", user: "Ministry of Ed", action: "Uploaded 12 new Math past papers", time: "30 mins ago", type: "upload"),
  const PlatformActivity(id: "pa2", user: "Jane Doe", action: "Registered as new Tutor", time: "2 hours ago", type: "registration"),
  const PlatformActivity(id: "pa3", user: "System", action: "Automated database backup completed", time: "4 hours ago", type: "system"),
  const PlatformActivity(id: "pa4", user: "Dr. Amara Nkosi", action: "Updated availability schedule", time: "5 hours ago", type: "system"),
];
