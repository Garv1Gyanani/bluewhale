import 'package:blue_whale/blue_whale.dart';

class CounterPod extends PersistentPod<int> {
  CounterPod() : super('main_counter', 0); // Saves to local storage instantly!

  void increment() => value++;
  void decrement() {
    if (value > 0) value--;
  }

  void reset() => value = 0;
}
