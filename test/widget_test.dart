import 'package:flutter_test/flutter_test.dart';

import 'package:nomad_puzzle/app/app.dart';

void main() {
  testWidgets('App builds without crashing', (tester) async {
    await tester.pumpWidget(const NomadPuzzleApp());
    expect(find.byType(NomadPuzzleApp), findsOneWidget);
  });
}
