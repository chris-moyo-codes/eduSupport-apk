// Student mock data for Phase 3 — derived from the web application's
// src/lib/mock-data.ts and src/lib/mock-tutors.ts as the authoritative source.
// All data is local and deterministic. No API connection.

// ─── Models ───────────────────────────────────────────────────────────────────

class StudentCourse {
  const StudentCourse({
    required this.id,
    required this.title,
    required this.subject,
    required this.grade,
    required this.progress,
    required this.isDownloaded,
    required this.lastAccessed,
  });

  final String id;
  final String title;
  final String subject;
  final String grade;
  final int progress;
  final bool isDownloaded;
  final String lastAccessed;
}

class StudentResource {
  StudentResource({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.subject,
    required this.grade,
    required this.offlineStatus,
    required this.dateAdded,
    this.author,
    this.fileSize,
    this.pages,
    this.isFeatured = false,
    this.isSaved = false,
    this.status = 'not_started',
  });

  final String id;
  final String title;
  final String description;
  final String type;
  final String subject;
  final String grade;
  final String offlineStatus;
  final String dateAdded;
  final String? author;
  final String? fileSize;
  final int? pages;
  final bool isFeatured;
  bool isSaved;
  String status;
}

class StudentFlashcard {
  const StudentFlashcard({
    required this.id,
    required this.front,
    required this.back,
    this.status = 'unseen',
  });

  final String id;
  final String front;
  final String back;
  final String status;
}

class StudentFlashcardDeck {
  const StudentFlashcardDeck({
    required this.id,
    required this.title,
    required this.subject,
    required this.totalCards,
    required this.cards,
  });

  final String id;
  final String title;
  final String subject;
  final int totalCards;
  final List<StudentFlashcard> cards;
}

class StudentQuizOption {
  const StudentQuizOption({required this.id, required this.text});
  final String id;
  final String text;
}

class StudentQuizQuestion {
  const StudentQuizQuestion({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionId,
    required this.explanation,
  });

  final String id;
  final String text;
  final List<StudentQuizOption> options;
  final String correctOptionId;
  final String explanation;
}

class StudentQuiz {
  const StudentQuiz({
    required this.id,
    required this.title,
    required this.subject,
    required this.questions,
  });

  final String id;
  final String title;
  final String subject;
  final List<StudentQuizQuestion> questions;
}

class StudentStudyItem {
  const StudentStudyItem({
    required this.id,
    required this.title,
    required this.subject,
    required this.type,
    required this.progress,
    required this.isCompleted,
  });

  final String id;
  final String title;
  final String subject;
  final String type;
  final int progress;
  final bool isCompleted;
}

class StudentTutorSubject {
  const StudentTutorSubject({required this.name, required this.level});
  final String name;
  final String level;
}

class StudentTutor {
  const StudentTutor({
    required this.id,
    required this.name,
    required this.initials,
    required this.tagline,
    required this.subjects,
    required this.rating,
    required this.reviewCount,
    required this.sessionsCompleted,
    required this.availability,
    required this.responseTime,
    required this.location,
    required this.languages,
    this.featured = false,
  });

  final String id;
  final String name;
  final String initials;
  final String tagline;
  final List<StudentTutorSubject> subjects;
  final double rating;
  final int reviewCount;
  final int sessionsCompleted;
  final String availability; // 'available' | 'busy' | 'offline'
  final String responseTime;
  final String location;
  final List<String> languages;
  final bool featured;
}

class StudentSession {
  const StudentSession({
    required this.id,
    required this.tutorId,
    required this.tutorName,
    required this.tutorInitials,
    required this.subject,
    required this.topic,
    required this.date,
    required this.time,
    required this.durationMinutes,
    required this.status,
    this.notes,
  });

  final String id;
  final String tutorId;
  final String tutorName;
  final String tutorInitials;
  final String subject;
  final String topic;
  final String date;
  final String time;
  final int durationMinutes;
  final String status; // 'upcoming' | 'active' | 'completed' | 'cancelled'
  final String? notes;
}

class WeeklyActivity {
  const WeeklyActivity({required this.day, required this.hours});
  final String day;
  final double hours;
}

// ─── Mock Data ────────────────────────────────────────────────────────────────

const studentCourses = <StudentCourse>[
  StudentCourse(
    id: 'c1',
    title: 'Introduction to Cell Biology',
    subject: 'Biology',
    grade: 'Grade 10',
    progress: 45,
    isDownloaded: true,
    lastAccessed: '2 hours ago',
  ),
  StudentCourse(
    id: 'c2',
    title: 'Algebraic Foundations',
    subject: 'Mathematics',
    grade: 'Grade 10',
    progress: 12,
    isDownloaded: false,
    lastAccessed: 'Yesterday',
  ),
  StudentCourse(
    id: 'c3',
    title: 'Mechanics & Thermodynamics',
    subject: 'Physics',
    grade: 'Grade 11',
    progress: 88,
    isDownloaded: true,
    lastAccessed: '3 days ago',
  ),
];

const studentWeeklyActivity = <WeeklyActivity>[
  WeeklyActivity(day: 'M', hours: 2.5),
  WeeklyActivity(day: 'T', hours: 3.0),
  WeeklyActivity(day: 'W', hours: 1.5),
  WeeklyActivity(day: 'T', hours: 4.0),
  WeeklyActivity(day: 'F', hours: 2.0),
  WeeklyActivity(day: 'S', hours: 0),
  WeeklyActivity(day: 'S', hours: 5.5),
];

final studentResources = <StudentResource>[
  StudentResource(
    id: 'r1',
    title: 'Advanced Mathematics Grade 12 Textbook',
    description:
        'Complete curriculum coverage for Grade 12 Mathematics including calculus and trigonometry.',
    type: 'Textbook',
    subject: 'Mathematics',
    grade: 'Grade 12',
    author: 'Ministry of Education',
    offlineStatus: 'available',
    dateAdded: '2023-08-12',
    fileSize: '14.2 MB',
    pages: 342,
    isFeatured: true,
    isSaved: true,
    status: 'in_progress',
  ),
  StudentResource(
    id: 'r2',
    title: 'Biology 2022 National Past Paper',
    description: 'Previous year examination paper with marking scheme.',
    type: 'Past Paper',
    subject: 'Biology',
    grade: 'Grade 12',
    offlineStatus: 'download_available',
    dateAdded: '2023-01-15',
    fileSize: '2.1 MB',
    pages: 18,
  ),
  StudentResource(
    id: 'r3',
    title: 'Chemical Bonding Summary Notes',
    description:
        'Condensed revision notes focusing on covalent, ionic, and metallic bonding.',
    type: 'Notes',
    subject: 'Chemistry',
    grade: 'Grade 11',
    author: 'Dr. Sarah Phiri',
    offlineStatus: 'pending_sync',
    dateAdded: '2023-09-02',
    fileSize: '1.5 MB',
    pages: 12,
  ),
  StudentResource(
    id: 'r4',
    title: 'Physics Mechanics Mini-Quiz',
    description: "Test your understanding of Newton's laws of motion.",
    type: 'Quiz',
    subject: 'Physics',
    grade: 'Grade 11',
    offlineStatus: 'available',
    dateAdded: '2023-10-10',
  ),
  StudentResource(
    id: 'r5',
    title: 'Introduction to Geography',
    description: 'Standard textbook for physical and human geography.',
    type: 'Textbook',
    subject: 'Geography',
    grade: 'Grade 10',
    author: 'Educational Trust',
    offlineStatus: 'downloading',
    dateAdded: '2023-07-20',
    fileSize: '8.4 MB',
    pages: 210,
  ),
  StudentResource(
    id: 'r6',
    title: 'English Literature Poetry Guide',
    description: 'Analysis of the top 10 poems required for the syllabus.',
    type: 'Study Guide',
    subject: 'English',
    grade: 'Grade 12',
    author: 'Jonathan Doe',
    offlineStatus: 'unavailable',
    dateAdded: '2023-11-01',
    fileSize: '3.2 MB',
    pages: 45,
  ),
];

const studentFlashcardDeck = StudentFlashcardDeck(
  id: 'deck-1',
  title: 'Cell Organelles',
  subject: 'Biology',
  totalCards: 4,
  cards: [
    StudentFlashcard(
      id: 'fc1',
      front: 'What is the primary function of the mitochondria?',
      back:
          "It generates most of the cell's supply of adenosine triphosphate (ATP), used as a source of chemical energy. Often called the 'powerhouse of the cell'.",
    ),
    StudentFlashcard(
      id: 'fc2',
      front: 'What organelle is responsible for photosynthesis in plant cells?',
      back:
          'Chloroplasts. They contain chlorophyll which absorbs light energy.',
    ),
    StudentFlashcard(
      id: 'fc3',
      front: 'What is the function of the rough endoplasmic reticulum?',
      back:
          "Protein synthesis and processing. It is 'rough' because it is studded with ribosomes.",
    ),
    StudentFlashcard(
      id: 'fc4',
      front: 'Where is the genetic material stored in a eukaryotic cell?',
      back: 'The Nucleus.',
    ),
  ],
);

const studentQuiz = StudentQuiz(
  id: 'quiz-1',
  title: "Newton's Laws of Motion",
  subject: 'Physics',
  questions: [
    StudentQuizQuestion(
      id: 'q1',
      text:
          "According to Newton's First Law, an object at rest will stay at rest unless acted upon by...",
      options: [
        StudentQuizOption(id: 'o1', text: 'an internal force'),
        StudentQuizOption(id: 'o2', text: 'an unbalanced external force'),
        StudentQuizOption(id: 'o3', text: 'gravity'),
        StudentQuizOption(id: 'o4', text: 'friction'),
      ],
      correctOptionId: 'o2',
      explanation:
          "Newton's First Law (Inertia) states that an object will not change its motion unless an unbalanced external force acts on it.",
    ),
    StudentQuizQuestion(
      id: 'q2',
      text: "Newton's Second Law can be mathematically expressed as:",
      options: [
        StudentQuizOption(id: 'o1', text: 'F = m / a'),
        StudentQuizOption(id: 'o2', text: 'F = m + a'),
        StudentQuizOption(id: 'o3', text: 'F = ma'),
        StudentQuizOption(id: 'o4', text: 'E = mc²'),
      ],
      correctOptionId: 'o3',
      explanation: 'Force equals mass times acceleration (F=ma).',
    ),
    StudentQuizQuestion(
      id: 'q3',
      text:
          'If you push a wall with a force of 50N, how much force does the wall exert on you?',
      options: [
        StudentQuizOption(id: 'o1', text: '0N'),
        StudentQuizOption(id: 'o2', text: '25N'),
        StudentQuizOption(id: 'o3', text: '50N'),
        StudentQuizOption(id: 'o4', text: '100N'),
      ],
      correctOptionId: 'o3',
      explanation:
          "According to Newton's Third Law, for every action there is an equal and opposite reaction.",
    ),
  ],
);

const studentStudyItems = <StudentStudyItem>[
  StudentStudyItem(
    id: 'flash-1',
    title: 'Cell Organelles',
    subject: 'Biology',
    type: 'Flashcards',
    progress: 0,
    isCompleted: false,
  ),
  StudentStudyItem(
    id: 'quiz-1',
    title: "Newton's Laws of Motion",
    subject: 'Physics',
    type: 'Quiz',
    progress: 0,
    isCompleted: false,
  ),
  StudentStudyItem(
    id: 'quiz-2',
    title: 'Algebraic Equations Practice',
    subject: 'Mathematics',
    type: 'Quiz',
    progress: 100,
    isCompleted: true,
  ),
  StudentStudyItem(
    id: 'flash-2',
    title: 'Chemical Elements Review',
    subject: 'Chemistry',
    type: 'Flashcards',
    progress: 45,
    isCompleted: false,
  ),
];

const studentTutors = <StudentTutor>[
  StudentTutor(
    id: 't1',
    name: 'Dr. Amara Nkosi',
    initials: 'AN',
    tagline:
        'Mathematics and Physics specialist with 8 years of secondary teaching experience.',
    subjects: [
      StudentTutorSubject(name: 'Mathematics', level: 'Grade 10–12'),
      StudentTutorSubject(name: 'Physics', level: 'Grade 11–12'),
    ],
    rating: 4.9,
    reviewCount: 134,
    sessionsCompleted: 312,
    availability: 'available',
    responseTime: 'Usually within 2 hours',
    location: 'Lilongwe',
    languages: ['English', 'Chichewa'],
    featured: true,
  ),
  StudentTutor(
    id: 't2',
    name: 'Chisomo Banda',
    initials: 'CB',
    tagline:
        'Biology and Chemistry tutor focused on exam preparation and MSCE success.',
    subjects: [
      StudentTutorSubject(name: 'Biology', level: 'Grade 10–12'),
      StudentTutorSubject(name: 'Chemistry', level: 'Grade 11–12'),
    ],
    rating: 4.7,
    reviewCount: 89,
    sessionsCompleted: 205,
    availability: 'available',
    responseTime: 'Usually within 1 hour',
    location: 'Blantyre',
    languages: ['English', 'Chichewa'],
    featured: true,
  ),
  StudentTutor(
    id: 't3',
    name: 'Takondwa Phiri',
    initials: 'TP',
    tagline:
        'English Literature tutor and writer. Specialises in essay writing and critical analysis.',
    subjects: [
      StudentTutorSubject(name: 'English Literature', level: 'Grade 10–12'),
      StudentTutorSubject(name: 'English Language', level: 'Grade 10–12'),
    ],
    rating: 4.8,
    reviewCount: 67,
    sessionsCompleted: 148,
    availability: 'busy',
    responseTime: 'Usually within 4 hours',
    location: 'Zomba',
    languages: ['English'],
  ),
  StudentTutor(
    id: 't4',
    name: 'Mercy Kayira',
    initials: 'MK',
    tagline:
        'Geography and History specialist. Making social studies engaging and accessible.',
    subjects: [
      StudentTutorSubject(name: 'Geography', level: 'Grade 10–12'),
      StudentTutorSubject(name: 'History', level: 'Grade 10–11'),
    ],
    rating: 4.6,
    reviewCount: 43,
    sessionsCompleted: 91,
    availability: 'available',
    responseTime: 'Usually within 3 hours',
    location: 'Mzuzu',
    languages: ['English', 'Chichewa', 'Tumbuka'],
  ),
  StudentTutor(
    id: 't5',
    name: 'Jonathan Mwale',
    initials: 'JM',
    tagline: 'Commerce and Accounting tutor with professional accounting background.',
    subjects: [
      StudentTutorSubject(name: 'Commerce', level: 'Grade 10–12'),
      StudentTutorSubject(name: 'Accounting', level: 'Grade 11–12'),
    ],
    rating: 4.5,
    reviewCount: 28,
    sessionsCompleted: 56,
    availability: 'offline',
    responseTime: 'Usually within 24 hours',
    location: 'Lilongwe',
    languages: ['English'],
  ),
];

const studentSessions = <StudentSession>[
  StudentSession(
    id: 'sess-1',
    tutorId: 't1',
    tutorName: 'Dr. Amara Nkosi',
    tutorInitials: 'AN',
    subject: 'Mathematics',
    topic: 'Calculus: Derivatives and Integration',
    date: 'Tomorrow',
    time: '14:00 CAT',
    durationMinutes: 60,
    status: 'upcoming',
  ),
  StudentSession(
    id: 'sess-2',
    tutorId: 't2',
    tutorName: 'Chisomo Banda',
    tutorInitials: 'CB',
    subject: 'Biology',
    topic: 'Cell Division — Mitosis and Meiosis',
    date: 'Saturday, 9 Aug',
    time: '10:00 CAT',
    durationMinutes: 45,
    status: 'upcoming',
  ),
  StudentSession(
    id: 'sess-3',
    tutorId: 't1',
    tutorName: 'Dr. Amara Nkosi',
    tutorInitials: 'AN',
    subject: 'Physics',
    topic: "Newton's Laws of Motion",
    date: '26 Jul 2025',
    time: '15:00 CAT',
    durationMinutes: 60,
    status: 'completed',
    notes:
        'Covered all three laws. Good progress on problem sets. Review circular motion before the next session.',
  ),
  StudentSession(
    id: 'sess-4',
    tutorId: 't3',
    tutorName: 'Takondwa Phiri',
    tutorInitials: 'TP',
    subject: 'English Literature',
    topic: 'Essay Structure and Analytical Writing',
    date: '19 Jul 2025',
    time: '13:00 CAT',
    durationMinutes: 45,
    status: 'completed',
    notes:
        'Worked through introduction and body paragraph construction. Homework: write one practice essay on a prescribed poem.',
  ),
];

// ─── Phase 2: Task / Submission Models ───────────────────────────────────────

enum TaskStatus { pending, submitted, graded, overdue }

enum SubmissionType { text, file, both }

class TaskSubmission {
  const TaskSubmission({
    required this.id,
    required this.taskId,
    required this.submittedAt,
    this.textResponse,
    this.fileName,
    this.fileSize,
    this.fileType,
  });

  final String id;
  final String taskId;
  final String submittedAt;
  final String? textResponse;
  final String? fileName;
  final String? fileSize;
  final String? fileType;
}

class StudentTask {
  const StudentTask({
    required this.id,
    required this.title,
    required this.subject,
    required this.grade,
    required this.description,
    required this.instructions,
    required this.tutorName,
    required this.tutorInitials,
    required this.dueDate,
    required this.dueDateLabel,
    required this.status,
    required this.submissionType,
    this.submission,
    this.awardedGrade,
    this.gradeFeedback,
  });

  final String id;
  final String title;
  final String subject;
  final String grade;
  final String description;
  final String instructions;
  final String tutorName;
  final String tutorInitials;
  final String dueDate;
  final String dueDateLabel;
  final TaskStatus status;
  final SubmissionType submissionType;
  final TaskSubmission? submission;
  final String? awardedGrade;
  final String? gradeFeedback;
}

const mockStudentTasks = <StudentTask>[
  StudentTask(
    id: 'task-1',
    title: 'Essay: The Cell and Its Functions',
    subject: 'Biology',
    grade: 'Grade 10',
    description: 'Write a structured essay explaining the key organelles of an animal cell and their functions.',
    instructions: 'Your essay should be 400–600 words. Address at minimum: the nucleus, mitochondria, endoplasmic reticulum, and Golgi apparatus. Use correct scientific terminology throughout.',
    tutorName: 'Chisomo Banda',
    tutorInitials: 'CB',
    dueDate: '2026-08-08T17:00:00Z',
    dueDateLabel: 'Fri, 8 Aug · 5:00 PM',
    status: TaskStatus.pending,
    submissionType: SubmissionType.both,
  ),
  StudentTask(
    id: 'task-2',
    title: 'Problem Set: Algebraic Equations',
    subject: 'Mathematics',
    grade: 'Grade 10',
    description: 'Complete the assigned problem set on linear and quadratic equations.',
    instructions: 'Solve all 10 problems showing full working. Scan or photograph your completed worksheet and submit. You may also type your solutions if you prefer.',
    tutorName: 'Dr. Amara Nkosi',
    tutorInitials: 'AN',
    dueDate: '2026-08-06T12:00:00Z',
    dueDateLabel: 'Wed, 6 Aug · 12:00 PM',
    status: TaskStatus.submitted,
    submissionType: SubmissionType.file,
    submission: TaskSubmission(
      id: 'sub-2',
      taskId: 'task-2',
      fileName: 'algebra_problemset_jonathan.pdf',
      fileSize: '1.2 MB',
      fileType: 'PDF',
      submittedAt: '2026-08-05T09:14:00Z',
    ),
  ),
  StudentTask(
    id: 'task-3',
    title: "Reflection: Newton's Laws in Daily Life",
    subject: 'Physics',
    grade: 'Grade 11',
    description: "Write a short reflection on how Newton's three laws of motion apply to everyday experiences.",
    instructions: "Write 200–300 words identifying one real-world example of each of Newton's three laws. Be specific — describe the exact forces involved.",
    tutorName: 'Dr. Amara Nkosi',
    tutorInitials: 'AN',
    dueDate: '2026-07-30T17:00:00Z',
    dueDateLabel: 'Wed, 30 Jul · 5:00 PM',
    status: TaskStatus.graded,
    submissionType: SubmissionType.text,
    submission: TaskSubmission(
      id: 'sub-3',
      taskId: 'task-3',
      textResponse: "Newton's First Law can be seen when a passenger leans forward during sudden braking. Second Law is demonstrated by the effort needed to push a heavy trolley. Third Law is evident when pushing off a wall while swimming.",
      submittedAt: '2026-07-29T16:45:00Z',
    ),
    awardedGrade: "8/10",
    gradeFeedback: "Good real-world examples across all three laws. Work on expanding the Second Law discussion — mention the formula F=ma explicitly.",
  ),
];

