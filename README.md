Take screenshots during your flutter unit tests. 

## usage


- Wrap your widget tree with a `Screenshotter` widget
- call `tester.screenshot()`
- profit


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


