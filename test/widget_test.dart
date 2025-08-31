import 'package:flutter_test/flutter_test.dart';

import 'package:wort_wirbel/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WortWirbelApp());

    expect(find.text('Willkommen to Wort-Wirbel!'), findsOneWidget);
    expect(find.text('Your German flashcard learning journey starts here.'),
        findsOneWidget);
  });
}
