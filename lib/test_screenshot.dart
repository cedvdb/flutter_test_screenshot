import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

extension ExtendedTestWidget on WidgetTester {
  /// returns bytes of a screenshot of the screen, useful for making a
  /// diagnostic for unit test failures.
  Future<Uint8List> _takeScreenshot() async {
    final renderObj = renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey('screenshotter')),
    );
    ui.Image image = await renderObj.toImage(pixelRatio: 3);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw 'could not transform image to bytes';
    }
    return byteData.buffer.asUint8List();
  }

  Future<void> screenshot({String? path}) async {
    await runAsync(() async {
      final screenshot = await _takeScreenshot();
      // Write the PNG formatted data to a file.
      final png = img.decodePng(screenshot);
      if (png == null) {
        throw 'could not decode img';
      }
      await File(
        path ?? 'screenshot-${DateTime.now().toIso8601String()}.png',
      ).writeAsBytes(img.encodePng(png));
    });
  }

  /// prints base64 screenshot unit test to console (this may be blocking the test)
  Future<void> printScreenshot() async {
    await runAsync(() async {
      final screenshot = await _takeScreenshot();
      String base64 = base64Encode(screenshot);
      // ignore: avoid_print
      print(base64);
    });
  }
}

class Screenshotter extends StatelessWidget {
  final Widget child;

  const Screenshotter({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(key: const ValueKey('screenshotter'), child: child);
  }
}
