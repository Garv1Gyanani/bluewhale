import 'package:blue_whale/blue_whale.dart';

class CounterPod extends WhalePod<int> {
  CounterPod() : super(0); // Initial count is 0

  void increment() => value++;
  void decrement() {
    if (value > 0) value--;
  }
  void reset() => value = 0;
}