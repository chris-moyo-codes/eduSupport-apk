

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

class TutorApplication {
  const TutorApplication({
    required this.id,
    required this.name,
    required this.email,
    required this.subjects,
    required this.status,
    required this.submittedDate,
  });

  final String id;
  final String name;
  final String email;
  final List<String> subjects;
  final String status; // 'pending', 'approved', 'rejected'
  final String submittedDate;
}

class AdminReport {
  const AdminReport({
    required this.id,
    required this.targetName,
    required this.targetRole,
    required this.category,
    required this.status,
    required this.date,
  });

  final String id;
  final String targetName;
  final String targetRole; // 'student' or 'tutor'
  final String category;
  final String status; // 'open', 'resolved'
  final String date;
}

class FinanceMetrics {
  const FinanceMetrics({
    required this.totalRevenue,
    required this.tutorPayouts,
    required this.platformFees,
    required this.pendingWithdrawals,
  });

  final double totalRevenue;
  final double tutorPayouts;
  final double platformFees;
  final double pendingWithdrawals;
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

final List<TutorApplication> initialTutorApplications = [
  const TutorApplication(id: 'app1', name: 'Dr. Sarah Chen', email: 'sarah.c@example.com', subjects: ['Physics', 'Math'], status: 'pending', submittedDate: '2 hours ago'),
  const TutorApplication(id: 'app2', name: 'James Phiri', email: 'james.p@example.com', subjects: ['Biology'], status: 'pending', submittedDate: 'Yesterday'),
  const TutorApplication(id: 'app3', name: 'Martha Banda', email: 'martha.b@example.com', subjects: ['English'], status: 'approved', submittedDate: '3 days ago'),
];

final List<AdminReport> initialAdminReports = [
  const AdminReport(id: 'rep1', targetName: 'David Osei', targetRole: 'student', category: 'Harassment', status: 'open', date: '5 hours ago'),
  const AdminReport(id: 'rep2', targetName: 'Prof. Arthur Pendelton', targetRole: 'tutor', category: 'No-show', status: 'open', date: '1 day ago'),
  const AdminReport(id: 'rep3', targetName: 'Emma Mwangi', targetRole: 'student', category: 'Spam', status: 'resolved', date: '3 days ago'),
];

const FinanceMetrics initialFinanceMetrics = FinanceMetrics(
  totalRevenue: 2500000.0,
  tutorPayouts: 2125000.0,
  platformFees: 375000.0,
  pendingWithdrawals: 45000.0,
);
