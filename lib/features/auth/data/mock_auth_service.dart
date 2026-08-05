// DEMO-ONLY MOBILE AUTHENTICATION
// ─────────────────────────────────
// This module provides a frontend-only mock authentication system.
// It mirrors the web app's auth-context.tsx exactly:
// same roles, same demo credentials, same session persistence approach.
//
// ⚠️  DEMO CREDENTIALS — NEVER USE IN PRODUCTION ⚠️
// Replace [SecureMockUserStore] with a real backend auth integration
// in a future phase. The [AuthController] interface is backend-agnostic.

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ─── Role ─────────────────────────────────────────────────────────────────────

enum EduRole { student, tutor, admin }

extension EduRoleX on EduRole {
  String get name {
    switch (this) {
      case EduRole.student:
        return 'student';
      case EduRole.tutor:
        return 'tutor';
      case EduRole.admin:
        return 'admin';
    }
  }

  static EduRole fromString(String value) {
    switch (value) {
      case 'tutor':
        return EduRole.tutor;
      case 'admin':
        return EduRole.admin;
      default:
        return EduRole.student;
    }
  }
}

// ─── User ─────────────────────────────────────────────────────────────────────

class EduUser {
  const EduUser({
    required this.id,
    required this.name,
    required this.email,
    required this.initials,
    required this.role,
  });

  final String id;
  final String name;
  final String email;
  final String initials;
  final EduRole role;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'initials': initials,
    'role': role.name,
  };

  factory EduUser.fromJson(Map<String, dynamic> json) => EduUser(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    initials: json['initials'] as String,
    role: EduRoleX.fromString(json['role'] as String? ?? 'student'),
  );
}

// ─── Demo Registry (mirrors web's auth-context.tsx) ──────────────────────────

const _demoUsers = <String, EduUser>{
  'student@edusupport.demo': EduUser(
    id: 'u_student_1',
    name: 'Jonathan Doe',
    email: 'student@edusupport.demo',
    initials: 'JD',
    role: EduRole.student,
  ),
  'tutor@edusupport.demo': EduUser(
    id: 'u_tutor_1',
    name: 'Dr. Amara Nkosi',
    email: 'tutor@edusupport.demo',
    initials: 'AN',
    role: EduRole.tutor,
  ),
  'admin@edusupport.demo': EduUser(
    id: 'u_admin_1',
    name: 'System Admin',
    email: 'admin@edusupport.demo',
    initials: 'SA',
    role: EduRole.admin,
  ),
};

// ⚠️ DEMO ONLY — client-side passwords, never expose in production
const _demoPasswords = <String, String>{
  'student@edusupport.demo': 'Student@123',
  'tutor@edusupport.demo': 'Tutor@123',
  'admin@edusupport.demo': 'Admin@123',
};

const _sessionKey = 'edu_demo_session_v1';

// ─── Store Interface ──────────────────────────────────────────────────────────

abstract class MockUserStore {
  Future<EduUser?> loadSession();
  Future<void> saveSession(EduUser user);
  Future<void> clearSession();
}

// ─── Secure Storage Implementation ───────────────────────────────────────────

class SecureMockUserStore implements MockUserStore {
  SecureMockUserStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<EduUser?> loadSession() async {
    try {
      final raw = await _storage.read(key: _sessionKey);
      if (raw == null) return null;
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return EduUser.fromJson(json);
    } catch (_) {
      await _storage.delete(key: _sessionKey);
      return null;
    }
  }

  @override
  Future<void> saveSession(EduUser user) async {
    await _storage.write(
      key: _sessionKey,
      value: jsonEncode(user.toJson()),
    );
  }

  @override
  Future<void> clearSession() async {
    await _storage.delete(key: _sessionKey);
  }
}

// ─── Login Result ─────────────────────────────────────────────────────────────

class LoginResult {
  const LoginResult.success(this.user) : error = null;
  const LoginResult.failure(this.error) : user = null;

  final EduUser? user;
  final String? error;

  bool get isSuccess => user != null;
}

// ─── Auth Service (stateless, injectable) ────────────────────────────────────

class MockAuthService {
  const MockAuthService(this._store);

  final MockUserStore _store;

  Future<EduUser?> restoreSession() => _store.loadSession();

  Future<LoginResult> login(String email, String password) async {
    // Simulate network latency
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final normalised = email.toLowerCase().trim();
    final user = _demoUsers[normalised];

    if (user == null) {
      return const LoginResult.failure(
        'No account found. Try student@edusupport.demo, '
        'tutor@edusupport.demo, or admin@edusupport.demo.',
      );
    }

    if (password != _demoPasswords[normalised]) {
      return const LoginResult.failure('Incorrect password. Please try again.');
    }

    await _store.saveSession(user);
    return LoginResult.success(user);
  }

  Future<void> logout() => _store.clearSession();
}
