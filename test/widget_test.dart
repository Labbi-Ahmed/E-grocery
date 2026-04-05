import 'package:flutter_test/flutter_test.dart';
import 'package:e_grocery/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EGroceryApp());
    await tester.pump();
  });
}
