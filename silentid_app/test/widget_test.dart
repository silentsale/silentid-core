import 'package:flutter_test/flutter_test.dart';
import 'package:silentid_app/main.dart';

void main() {
  testWidgets('App starts with Welcome Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SilentIDApp());

    // Wait for async operations
    await tester.pumpAndSettle();

    // Verify that welcome screen text is displayed
    expect(find.text('Welcome to SilentID'), findsOneWidget);
    expect(find.text('Your portable trust passport.'), findsOneWidget);
  });
}
