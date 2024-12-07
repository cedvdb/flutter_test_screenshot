Take screenshots during your unit tests or integration tests. 

## usage


You must first wrap your test with a screenshotter, then you can take screenshot.

The `screenshot()` method is added on the widget tester, so you can call `screenshot()` on the widgetTester.

```dart
  testWidgets('should create a screenshot', (tester) async {
    await tester.pumpWidget(
      Screenshotter(
        child: MaterialApp(
          home: Scaffold(body: Center(child: Icon(Icons.home))),
        ),
      ),
    );

    await tester.screenshot(path: file.path);
  });
```


