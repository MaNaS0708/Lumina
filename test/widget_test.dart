import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/app/lumina_app.dart';
import 'package:lumina/controllers/navigation_controller.dart';

void main() {
  testWidgets('Lumina preview login renders', (tester) async {
    await tester.pumpWidget(
      LuminaApp(navigationController: NavigationController()),
    );

    expect(find.text('Lumina'), findsOneWidget);
    expect(find.text('Continue as Employee'), findsOneWidget);
  });
}
