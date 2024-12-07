import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test_screenshot/test_screenshot.dart';

void main() {
  final file = File('./test/screenshot.png');

  setUp(() {
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  testWidgets('should create a screenshot', (tester) async {
    expect(file.existsSync(), false);

    await tester.pumpWidget(
      Screenshotter(
        child: MaterialApp(
          home: Scaffold(body: Center(child: Icon(Icons.home))),
        ),
      ),
    );

    await tester.screenshot(path: file.path);
    expect(file.existsSync(), true);
  });
}
