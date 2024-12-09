import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test_screenshot/test_screenshot.dart';

void main() {
  final file = File('./test/screenshot.png');
  final fileWithImage = File('./test/screenshot_with_image.png');

  setUpAll(() {
    if (file.existsSync()) {
      file.deleteSync();
    }
    if (fileWithImage.existsSync()) {
      fileWithImage.deleteSync();
    }
  });

  testWidgets('should create a screenshot', (tester) async {
    expect(file.existsSync(), false);

    await tester.pumpWidget(
      Screenshotter(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Below is an icon'),
                  Icon(Icons.home),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.screenshot(path: file.path);
    expect(file.existsSync(), true);
  });

  testWidgets('should create a screenshot with fonts and images',
      (tester) async {
    expect(fileWithImage.existsSync(), false);

    await tester.screenshotWithImages(() async {
      await tester.pumpWidget(
        Screenshotter(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Below is an icon'),
                    Icon(Icons.home),
                    Image.network(
                      'https://images.pexels.com/photos/1805164/pexels-photo-1805164.jpeg',
                      height: 300,
                      width: 300,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }, path: fileWithImage.path);

    expect(fileWithImage.existsSync(), true);
  });
}
