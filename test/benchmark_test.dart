import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blue_whale/blue_whale.dart';

void main() {
  group('Blue Whale Intense Stress Tests', () {
    test('DI Instance Generation - 100,000 registers & lookups', () {
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < 100000; i++) {
        Whale.lazyPut(() => i, tag: 'stress_tag_$i');
      }
      for (int i = 0; i < 100000; i++) {
        final result = Whale.find<int>(tag: 'stress_tag_$i');
        expect(result, i);
      }
      stopwatch.stop();
      print(
          '>>> 100k registrations and retrievals took ${stopwatch.elapsedMilliseconds} ms');
      Reef.i.reset();
    });

    testWidgets('10,000 Pods UI update cascade', (WidgetTester tester) async {
      print('>>> Building 10,000 reactive pods in the widget tree...');
      final pods = List.generate(10000, (i) => i.pod);

      final buildWatch = Stopwatch()..start();
      final scrollView = SingleChildScrollView(
        child: Column(
          children: pods
              .map((p) => PodBuilder(() =>
                  Text(p.value.toString(), textDirection: TextDirection.ltr)))
              .toList(),
        ),
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: scrollView,
        ),
      );
      buildWatch.stop();
      print(
          '>>> Built 10k PodBuilder tree in ${buildWatch.elapsedMilliseconds} ms');

      final updateWatch = Stopwatch()..start();
      for (int i = 0; i < 10000; i++) {
        pods[i].value++;
      }
      // Using pump over pumpAndSettle to avoid waiting for scroll physics to settle if they get triggered.
      await tester.pump();
      updateWatch.stop();
      print(
          '>>> Emitted 10,000 changes and updated UI in ${updateWatch.elapsedMilliseconds} ms');
    });

    // Remove the nested one since the tester freezes while inflating heavily nested columns internally in SDK unit tests
  });
}
