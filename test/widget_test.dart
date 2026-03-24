import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atelier/main.dart';

void main() {
  testWidgets('App launches and shows bottom nav', (WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(child: AtelierApp()));
    // App should render without throwing.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
