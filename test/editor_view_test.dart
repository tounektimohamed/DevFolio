import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:folio/configs/app.dart';
import 'package:folio/data/active_data.dart';
import 'package:folio/data/default_portfolio.dart';
import 'package:folio/provider/portfolio_provider.dart';
import 'package:folio/sections/admin/editor_screen.dart';
import 'package:provider/provider.dart';

Widget harness() => MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PortfolioProvider.ensureInstance(),
        ),
      ],
      child: MaterialApp(
        home: Builder(
          builder: (context) {
            App.init(context);
            return const PortfolioEditorView(uid: 'test-uid');
          },
        ),
      ),
    );

void main() {
  testWidgets('editor renders authenticated view without errors',
      (tester) async {
    setActivePortfolio(buildDefaultPortfolio());
    await tester.pumpWidget(harness());
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(tester.takeException(), isNull);
    expect(find.text('Portfolio Studio'), findsOneWidget);
  });
}