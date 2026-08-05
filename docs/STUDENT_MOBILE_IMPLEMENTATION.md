# Student Mobile Implementation Guide (Phase 3)

## Architecture Overview

The EduSupport mobile application replicates the core student experience of the web application. 
This phase extends the foundational UI into a fully interactive mock frontend. No backend or API integrations exist; everything is driven by local mock data simulating a fast, responsive mobile app.

### Navigation Hierarchy
- **ShellScreen**: The root view containing the bottom navigation bar.
- **Tabs**: Home (Dashboard), Library, Study, Tutors, Profile.
- **Secondary Modals/Screens**: Sessions (accessed via FAB on Home), Downloads (accessed via Profile settings), FlashcardViewer (pushed from Study).

## Screen Inventory & Web Mapping

| Mobile Screen | Web Reference | Key Adaptations for Mobile |
|---|---|---|
| `DashboardScreen` | `/dashboard` | The desktop activity chart is replaced by 7 vertical CSS-style containers. The "Live Now" banner is adapted into an upcoming session card. |
| `LibraryScreen` | `/library` | Horizontal scrollable filter chips instead of a sidebar filter. Sticky search bar at top. Offline badges styled identically to the web. |
| `StudyScreen` | `/study` | The "Up Next" flashcard deck uses a dark-themed hero card that pushes to a full-screen interactive card viewer rather than a split-pane layout. |
| `FlashcardViewerScreen` | `/study/flashcards/:id` | Full custom implementation of 3D card flips using Flutter's `AnimationController` and `Matrix4.rotationY`. |
| `TutorsScreen` | `/tutors` | Replicates the web's split between "Top-Rated" and "All". Star ratings, tags, and availability dots are pixel-perfect to the web's design system. |
| `SessionsScreen` | `/sessions` | Stacked card list mapping upcoming and past sessions, with the tutor's feedback visually separated with a thick left-border treatment. |
| `DownloadsScreen` | `/downloads` | Adapted from a primary sidebar route (web) to a secondary settings route (mobile) to fit the 5-tab constraint. Replicates storage usage bars and sync states. |
| `ProfileScreen` | `/profile` | Form toggles (Switches) and Segmented Buttons mapped to custom `_EduSwitch` and animated containers. |

## Mock Data Layer
The data driving these screens lives entirely in `lib/features/student/data/student_mock_data.dart`. 
It was meticulously transcribed from `src/lib/mock-data.ts` and `src/lib/mock-tutors.ts` in the web repository to guarantee product consistency.

*   5 Tutors with location and languages.
*   6 Resources reflecting 5 distinct offline syncing states.
*   4 Sessions (including the crucial "completed" state with tutor notes).
*   1 complete Flashcard Deck ("Cell Organelles") with 4 questions.
*   7 days of simulated study hours.

## Custom Components (`lib/core/widgets/`)
To achieve the web app's bespoke styling, several custom widgets were created or extended:
*   `EduSearchField`: A branded search input with a muted border that turns brand-color on focus.
*   `EduBadge`: Extended with `warning` and `error` tones for session statuses.
*   `EduStatChip`: A compact inline widget for displaying metadata like tutor response times.
*   `EduEmptyState`: Extended to accept flexible `IconData` and rounded grey backgrounds matching web empty states.

## Missing Features / Out of Scope for Phase 3
- Real authentication flows.
- Backend API connections.
- Interactive quizzes (the data exists, but the UI viewer is pending).
- Tutor/Admin roles. 

## Next Steps
The frontend implementation is now visually complete for the student persona. The next logical phases would involve state management integration (Riverpod connecting to real repositories) or expanding the app shell to accommodate Tutor roles.
