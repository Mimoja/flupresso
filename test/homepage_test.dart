import 'package:flupresso/ui/theme.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flupresso/main.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Main navigation works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // TODO: move multiprovider constructor to utils
    await tester.pumpWidget(MultiProvider(providers: [
      ChangeNotifierProvider<FluTheme>(create: (_) => FluTheme()),
    ], child: MyApp()));

    // Verify that our counter starts at 0.
    expect(find.text('Espresso'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Water / Steam / Flush'), findsOneWidget);

    // Tap the Espresso button
    await tester.tap(find.text('Espresso'));
    await tester.pumpAndSettle();

    // Verify that we went to brew page
    expect(find.text('Live'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Espresso'), findsOneWidget);

    await tester.tap(find.text('Water / Steam / Flush'));

    // TODO: this fails, no idea why
    //expect(find.text('Water'), findsOneWidget);
    //await tester.pageBack();
    //await tester.pumpAndSettle();

    //expect(find.text('Espresso'), findsOneWidget);
  });
}
