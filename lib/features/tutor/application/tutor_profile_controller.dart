// Tutor extended profile and verification state.
// Manages the editable professional profile and displays verification status.
// Kept separate from the auth layer.

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Verification Status ──────────────────────────────────────────────────────

enum TutorVerificationStatus {
  pending,
  verified,
  additionalInfoRequired,
  rejected,
}

extension TutorVerificationStatusX on TutorVerificationStatus {
  String get label {
    switch (this) {
      case TutorVerificationStatus.pending:
        return 'Pending Review';
      case TutorVerificationStatus.verified:
        return 'Verified';
      case TutorVerificationStatus.additionalInfoRequired:
        return 'Additional Info Required';
      case TutorVerificationStatus.rejected:
        return 'Not Approved';
    }
  }

  String get description {
    switch (this) {
      case TutorVerificationStatus.pending:
        return 'Your application is under review. This typically takes 2–3 business days.';
      case TutorVerificationStatus.verified:
        return 'Your account is verified. Students can find and book you on the marketplace.';
      case TutorVerificationStatus.additionalInfoRequired:
        return 'We need additional information to complete your verification. Please check your email.';
      case TutorVerificationStatus.rejected:
        return 'Your application was not approved at this time. Contact support for more information.';
    }
  }
}

// ─── Payout Methods ───────────────────────────────────────────────────────────

enum TutorPayoutMethod { mpamba, airtelMoney, bank }

extension TutorPayoutMethodX on TutorPayoutMethod {
  String get label {
    switch (this) {
      case TutorPayoutMethod.mpamba:
        return 'Mpamba';
      case TutorPayoutMethod.airtelMoney:
        return 'Airtel Money';
      case TutorPayoutMethod.bank:
        return 'Bank Account';
    }
  }
}

// ─── Model ────────────────────────────────────────────────────────────────────

class TutorSubjectEntry {
  const TutorSubjectEntry({required this.subject, required this.educationLevel});
  final String subject;
  final String educationLevel;
}

class TutorPayoutDetails {
  const TutorPayoutDetails({
    required this.method,
    required this.accountIdentifier,
    this.bankName,
  });

  final TutorPayoutMethod method;
  final String accountIdentifier; // mobile number or account number
  final String? bankName;
}

class TutorProfile {
  const TutorProfile({
    required this.name,
    required this.email,
    this.phone = '',
    this.bio = '',
    this.location = '',
    this.experienceYears = 0,
    this.subjectEntries = const [],
    this.qualifications = const [],
    this.certifications = const [],
    this.teachingStyle = '',
    this.languages = const [],
    this.sessionType = 'Online',
    this.sessionDurationMinutes = 60,
    this.hourlyRateMwk = 5000,
    this.verificationStatus = TutorVerificationStatus.verified,
    this.payoutDetails,
  });

  final String name;
  final String email;
  final String phone;
  final String bio;
  final String location;
  final int experienceYears;
  final List<TutorSubjectEntry> subjectEntries;
  final List<String> qualifications;
  final List<String> certifications;
  final String teachingStyle;
  final List<String> languages;
  final String sessionType;
  final int sessionDurationMinutes;
  final int hourlyRateMwk;
  final TutorVerificationStatus verificationStatus;
  final TutorPayoutDetails? payoutDetails;

  TutorProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? location,
    int? experienceYears,
    List<TutorSubjectEntry>? subjectEntries,
    List<String>? qualifications,
    List<String>? certifications,
    String? teachingStyle,
    List<String>? languages,
    String? sessionType,
    int? sessionDurationMinutes,
    int? hourlyRateMwk,
    TutorVerificationStatus? verificationStatus,
    TutorPayoutDetails? payoutDetails,
  }) {
    return TutorProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      experienceYears: experienceYears ?? this.experienceYears,
      subjectEntries: subjectEntries ?? this.subjectEntries,
      qualifications: qualifications ?? this.qualifications,
      certifications: certifications ?? this.certifications,
      teachingStyle: teachingStyle ?? this.teachingStyle,
      languages: languages ?? this.languages,
      sessionType: sessionType ?? this.sessionType,
      sessionDurationMinutes:
          sessionDurationMinutes ?? this.sessionDurationMinutes,
      hourlyRateMwk: hourlyRateMwk ?? this.hourlyRateMwk,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      payoutDetails: payoutDetails ?? this.payoutDetails,
    );
  }
}

// ─── Controller ───────────────────────────────────────────────────────────────

class TutorProfileController extends StateNotifier<TutorProfile> {
  TutorProfileController(TutorProfile initial) : super(initial);

  void updateProfile(TutorProfile updated) {
    state = updated;
  }

  void updatePayoutDetails(TutorPayoutDetails details) {
    state = state.copyWith(payoutDetails: details);
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final tutorProfileProvider =
    StateNotifierProvider<TutorProfileController, TutorProfile>((ref) {
  return TutorProfileController(
    TutorProfile(
      name: 'Dr. Amara Nkosi',
      email: 'tutor@edusupport.demo',
      phone: '+265 995 123 456',
      bio:
          'Mathematics and Physics specialist with 8 years of secondary and tertiary teaching experience. I am passionate about helping students develop genuine understanding rather than just memorising formulas. My approach is student-centred, adaptive, and focused on building confidence alongside subject mastery.',
      location: 'Lilongwe',
      experienceYears: 8,
      subjectEntries: const [
        TutorSubjectEntry(
            subject: 'Mathematics', educationLevel: 'Grade 10–12'),
        TutorSubjectEntry(subject: 'Physics', educationLevel: 'Grade 11–12'),
        TutorSubjectEntry(
            subject: 'Further Mathematics',
            educationLevel: 'University Entrance'),
      ],
      qualifications: const [
        'BSc Mathematics — University of Malawi',
        'MSc Applied Physics — University of Zimbabwe',
      ],
      certifications: const [
        'Teaching Certificate — MIE',
        'STEM Education Certificate — British Council',
      ],
      teachingStyle:
          'Socratic questioning combined with worked examples. I prioritise understanding over memorisation.',
      languages: const ['English', 'Chichewa'],
      sessionType: 'Online & In-Person',
      sessionDurationMinutes: 60,
      hourlyRateMwk: 7000,
      verificationStatus: TutorVerificationStatus.verified,
      payoutDetails: const TutorPayoutDetails(
        method: TutorPayoutMethod.mpamba,
        accountIdentifier: '088 *** ****',
      ),
    ),
  );
});
