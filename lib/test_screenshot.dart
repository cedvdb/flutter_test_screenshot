import 'dart:convert';
import 'dart:io' show HttpOverrides;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import 'package:platform/platform.dart';

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

  /// Takes a screenshot of the current view and saves it under [path].
  Future<void> screenshot({String? path}) async {
    const FileSystem fs = LocalFileSystem();

    await runAsync(() async {
      final screenshot = await _takeScreenshot();
      // Write the PNG formatted data to a file.
      final png = img.decodePng(screenshot);
      if (png == null) {
        throw 'could not decode img';
      }
      await fs
          .file(
            path ?? 'screenshot-${DateTime.now().toIso8601String()}.png',
          )
          .writeAsBytes(img.encodePng(png));
    });
  }

  /// This will run the [callback] provided then take a screenshot.
  /// The images and fonts will be displayed (currently supports default fonts).
  Future<void> screenshotWithImages(
    Future<void> Function() callback, {
    String? path,
  }) async {
    HttpOverrides.global = null;
    await _loadFonts();
    await runAsync(callback);
    await _loadImages();
    await screenshot(path: path);
  }

  Future<void> _loadImages() async {
    await runAsync(() async {
      for (var element in find.byType(Image).evaluate()) {
        final Image widget = element.widget as Image;
        final ImageProvider image = widget.image;
        await precacheImage(image, element);
      }
      await pumpAndSettle();
    });
  }

  /// Loads the cached material icon font and roboto font.
  Future<void> _loadFonts() async {
    const FileSystem fs = LocalFileSystem();
    const Platform platform = LocalPlatform();
    final Directory flutterRoot = fs.directory(
      platform.environment['FLUTTER_ROOT'],
    );

    final File iconFont = flutterRoot.childFile(
      fs.path.join(
        'bin',
        'cache',
        'artifacts',
        'material_fonts',
        'MaterialIcons-Regular.otf',
      ),
    );
    final File roboto = flutterRoot.childFile(
      fs.path.join(
        'bin',
        'cache',
        'artifacts',
        'material_fonts',
        'Roboto-Regular.ttf',
      ),
    );
    final Future<ByteData> iconFontBytes = Future<ByteData>.value(
      iconFont.readAsBytesSync().buffer.asByteData(),
    );

    final Future<ByteData> robotoFontBytes = Future<ByteData>.value(
      roboto.readAsBytesSync().buffer.asByteData(),
    );

    await (FontLoader('MaterialIcons')..addFont(iconFontBytes)).load();
    await (FontLoader('Roboto')..addFont(robotoFontBytes)).load();
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
