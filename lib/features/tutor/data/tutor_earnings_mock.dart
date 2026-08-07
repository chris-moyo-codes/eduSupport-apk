// EduSupport Tutor Earnings — Frontend-Only Mock
// ────────────────────────────────────────────────
// Business rules:
//   - EduSupport commission: 15%
//   - Tutor receives: 85%
//   - Minimum withdrawal: MWK 10,000
//
// All amounts are in MWK (Malawian Kwacha).

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

const double kEduSupportCommissionRate = 0.15;
const double kTutorShareRate = 0.85;
const int kMinimumWithdrawalMwk = 10000;

enum EarningStatus { paid, pending, refunded }

class TutorEarning {
  const TutorEarning({
    required this.id,
    required this.studentName,
    required this.subject,
    required this.durationMinutes,
    required this.grossAmountMwk,
    required this.dateLabel,
    this.status = EarningStatus.paid,
  });

  final String id;
  final String studentName;
  final String subject;
  final int durationMinutes;
  final int grossAmountMwk;
  final String dateLabel;
  final EarningStatus status;

  int get tutorAmountMwk => (grossAmountMwk * kTutorShareRate).round();
  int get platformAmountMwk => grossAmountMwk - tutorAmountMwk;
}

enum WithdrawalStatus { pending, completed, failed }

class TutorWithdrawal {
  const TutorWithdrawal({
    required this.id,
    required this.amountMwk,
    required this.method,
    required this.dateLabel,
    this.status = WithdrawalStatus.pending,
  });

  final String id;
  final int amountMwk;
  final String method;
  final String dateLabel;
  final WithdrawalStatus status;
}

class TutorBalance {
  const TutorBalance({
    required this.totalEarnedMwk,
    required this.availableForWithdrawalMwk,
    required this.totalWithdrawnMwk,
  });

  final int totalEarnedMwk;
  final int availableForWithdrawalMwk;
  final int totalWithdrawnMwk;

  bool get canWithdraw => availableForWithdrawalMwk >= kMinimumWithdrawalMwk;
}

// ─── Mock Data ────────────────────────────────────────────────────────────────

final mockTutorEarnings = <TutorEarning>[
  const TutorEarning(
    id: 'earn_1',
    studentName: 'Grace Banda',
    subject: 'Mathematics — Calculus',
    durationMinutes: 60,
    grossAmountMwk: 7000,
    dateLabel: '2 days ago',
    status: EarningStatus.paid,
  ),
  const TutorEarning(
    id: 'earn_2',
    studentName: 'Emmanuel Chirwa',
    subject: 'Physics — Mechanics',
    durationMinutes: 60,
    grossAmountMwk: 7000,
    dateLabel: '5 days ago',
    status: EarningStatus.paid,
  ),
  const TutorEarning(
    id: 'earn_3',
    studentName: 'Lucia Tembo',
    subject: 'Mathematics — Algebra',
    durationMinutes: 45,
    grossAmountMwk: 5500,
    dateLabel: '1 week ago',
    status: EarningStatus.paid,
  ),
  const TutorEarning(
    id: 'earn_4',
    studentName: 'Peter Mhango',
    subject: 'Physics — Waves',
    durationMinutes: 60,
    grossAmountMwk: 7000,
    dateLabel: '2 weeks ago',
    status: EarningStatus.paid,
  ),
  const TutorEarning(
    id: 'earn_5',
    studentName: 'Faith Msowoya',
    subject: 'Mathematics — Statistics',
    durationMinutes: 90,
    grossAmountMwk: 9500,
    dateLabel: '3 weeks ago',
    status: EarningStatus.paid,
  ),
  const TutorEarning(
    id: 'earn_6',
    studentName: 'Grace Banda',
    subject: 'Mathematics — Trigonometry',
    durationMinutes: 60,
    grossAmountMwk: 7000,
    dateLabel: '1 month ago',
    status: EarningStatus.refunded,
  ),
  const TutorEarning(
    id: 'earn_7',
    studentName: 'Jonathan Doe',
    subject: 'Physics — Thermodynamics',
    durationMinutes: 60,
    grossAmountMwk: 7000,
    dateLabel: 'Tomorrow',
    status: EarningStatus.pending,
  ),
];

final mockTutorWithdrawals = <TutorWithdrawal>[
  const TutorWithdrawal(
    id: 'wdraw_1',
    amountMwk: 30000,
    method: 'Mpamba',
    dateLabel: '2 weeks ago',
    status: WithdrawalStatus.completed,
  ),
  const TutorWithdrawal(
    id: 'wdraw_2',
    amountMwk: 20000,
    method: 'Mpamba',
    dateLabel: '1 month ago',
    status: WithdrawalStatus.completed,
  ),
];

// Available = paid earnings (85% share) minus already withdrawn
// Realistic: 5 paid sessions × ~6,000 avg = 30,000 MWK earned; 50,000 withdrawn previously
// Net available ≈ 15,000 MWK (above 10,000 minimum to show the enabled state by default)
const mockTutorBalance = TutorBalance(
  totalEarnedMwk: 65450, // cumulative tutor share across all paid sessions
  availableForWithdrawalMwk: 15450,
  totalWithdrawnMwk: 50000,
);

// ─── State & Controller ───────────────────────────────────────────────────────

class TutorEarningsState {
  const TutorEarningsState({
    required this.earnings,
    required this.withdrawals,
    required this.balance,
  });

  final List<TutorEarning> earnings;
  final List<TutorWithdrawal> withdrawals;
  final TutorBalance balance;
}

class TutorEarningsController extends StateNotifier<TutorEarningsState> {
  TutorEarningsController()
      : super(TutorEarningsState(
          earnings: List.from(mockTutorEarnings),
          withdrawals: List.from(mockTutorWithdrawals),
          balance: mockTutorBalance,
        ));

  /// Submits a mock withdrawal request. Returns a mock reference ID.
  String requestWithdrawal(int amountMwk, String method) {
    final refId = 'EDU-W-${DateTime.now().millisecondsSinceEpoch}';
    final withdrawal = TutorWithdrawal(
      id: refId,
      amountMwk: amountMwk,
      method: method,
      dateLabel: 'Processing',
      status: WithdrawalStatus.pending,
    );
    final newBalance = TutorBalance(
      totalEarnedMwk: state.balance.totalEarnedMwk,
      availableForWithdrawalMwk:
          state.balance.availableForWithdrawalMwk - amountMwk,
      totalWithdrawnMwk: state.balance.totalWithdrawnMwk + amountMwk,
    );
    state = TutorEarningsState(
      earnings: state.earnings,
      withdrawals: [withdrawal, ...state.withdrawals],
      balance: newBalance,
    );
    return refId;
  }
}

final tutorEarningsProvider =
    StateNotifierProvider<TutorEarningsController, TutorEarningsState>(
  (ref) => TutorEarningsController(),
);
