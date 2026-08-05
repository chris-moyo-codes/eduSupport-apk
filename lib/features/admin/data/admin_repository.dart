import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin_mock_data.dart';

abstract class IAdminRepository {
  Future<List<AdminAlert>> getAlerts();
  Future<void> acknowledgeAlert(String id);
  Future<List<AdminUser>> getUsers(String role);
  Future<void> setTutorStatus(String id, String status);
  Future<List<PlatformActivity>> getRecentActivity();
}

class MockAdminRepository implements IAdminRepository {
  final List<AdminAlert> _alerts = List.from(initialAdminAlerts);
  final List<AdminUser> _users = List.from(initialAdminUsers);
  final List<PlatformActivity> _activities = List.from(adminRecentActivity);

  @override
  Future<List<AdminAlert>> getAlerts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_alerts);
  }

  @override
  Future<void> acknowledgeAlert(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _alerts.indexWhere((a) => a.id == id);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(isAcknowledged: true);
    }
  }

  @override
  Future<List<AdminUser>> getUsers(String role) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _users.where((u) => u.role == role).toList();
  }

  @override
  Future<void> setTutorStatus(String id, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _users.indexWhere((u) => u.id == id && u.role == 'tutor');
    if (index != -1) {
      _users[index] = _users[index].copyWith(status: status);
    }
  }

  @override
  Future<List<PlatformActivity>> getRecentActivity() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_activities);
  }
}

final adminRepositoryProvider = Provider<IAdminRepository>((ref) {
  return MockAdminRepository();
});

final adminAlertsProvider = FutureProvider<List<AdminAlert>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  return repo.getAlerts();
});

final adminUsersProvider = FutureProvider.family<List<AdminUser>, String>((ref, role) async {
  final repo = ref.watch(adminRepositoryProvider);
  return repo.getUsers(role);
});

final adminActivityProvider = FutureProvider<List<PlatformActivity>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  return repo.getRecentActivity();
});
