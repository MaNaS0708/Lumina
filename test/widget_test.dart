import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/app/lumina_app.dart';
import 'package:lumina/controllers/navigation_controller.dart';

void main() {
  testWidgets('Lumina authentication screen renders', (tester) async {
    await tester.pumpWidget(
      LuminaApp(
        navigationController: NavigationController(),
        authStateChanges: Stream.value(null),
      ),
    );
    await tester.pump();

    expect(find.text('Lumina'), findsWidgets);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Continue to workspace'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
  });
}
