import 'package:flutter_test/flutter_test.dart';
import 'package:farrier_log/main.dart';

void main() {
  testWidgets('FarrierLog app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const FarrierLogApp());

    expect(find.text('FarrierLog'), findsOneWidget);
  });
}
