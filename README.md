Take screenshots during your flutter unit tests for debugging purpose. 

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

    await tester.screenshot(path: 'screenshot.png');
  });
```

## Fonts, icons and images

By default, flutter will use its own font during unit tests. It will also not allow network images to be rendered.

To allow fonts and network images you can use the `screenshotWithImages()` method.


```dart
  testWidgets('should create a screenshot with fonts and images',
      (tester) async {

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
      // do things...
    }, path: 'file_with_image.png');

  });

```

