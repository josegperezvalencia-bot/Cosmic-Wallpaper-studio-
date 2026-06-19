import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_wallpaper_studio/app.dart';

void main() {
  testWidgets('App should render', (WidgetTester tester) async {
    await tester.pumpWidget(const CosmicWallpaperApp());
    expect(find.text('COSMIC WALLPAPER'), findsOneWidget);
  });
}
