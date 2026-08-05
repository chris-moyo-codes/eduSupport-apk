import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edusupport_mobile/features/student/presentation/screens/downloads_screen.dart';

void main() {
  testWidgets('downloads screen renders storage bar and sections', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DownloadsScreen(),
      ),
    );

    expect(find.text('Offline Library'), findsOneWidget); // AppBar
    expect(find.text('Storage Used'), findsOneWidget);
    expect(find.text('Downloading'), findsOneWidget);
    expect(find.text('Pending Sync'), findsOneWidget);
    expect(find.text('Available Offline'), findsOneWidget);
    expect(find.text('Unavailable Offline'), findsOneWidget);

    // Verify some specific mocked items are rendered in the right sections
    expect(find.text('Introduction to Geography'), findsOneWidget); // downloading
    expect(find.text('Chemical Bonding Summary Notes'), findsOneWidget); // pending
    expect(find.text('English Literature Poetry Guide'), findsOneWidget); // unavailable
  });
}
