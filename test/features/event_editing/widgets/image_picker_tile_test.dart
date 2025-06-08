import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/features/event_editing/widgets/image_picker_tile.dart';

void main() {
  group('ImagePickerTile Widget Tests', () {
    late bool tapped;

    setUp(() {
      tapped = false;
    });

    testWidgets('shows upload prompt when no image', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImagePickerTile(
              image: null,
              onTap: () { tapped = true; },
            ),
          ),
        ),
      );

      expect(find.text('Upload Image'), findsOneWidget);
      expect(find.text('Tap to select an image'), findsOneWidget);
      await tester.tap(find.byType(GestureDetector));
      expect(tapped, isTrue);
    });

    testWidgets('displays image when provided', (WidgetTester tester) async {
      // create a temporary dummy file
      final file = File.fromUri(Uri.file('test/assets/test.png'));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImagePickerTile(
              image: file,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Tap to select an image'), findsOneWidget);
    });
  });
}