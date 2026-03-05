import 'pod.dart';

extension IntPodExt on int {
  WhalePod<int> get pod => WhalePod<int>(this);
}

extension DoublePodExt on double {
  WhalePod<double> get pod => WhalePod<double>(this);
}

extension StringPodExt on String {
  WhalePod<String> get pod => WhalePod<String>(this);
}

extension BoolPodExt on bool {
  WhalePod<bool> get pod => WhalePod<bool>(this);
}

extension ListPodExt<T> on List<T> {
  WhalePod<List<T>> get pod => WhalePod<List<T>>(this);
}

extension MapPodExt<K, V> on Map<K, V> {
  WhalePod<Map<K, V>> get pod => WhalePod<Map<K, V>>(this);
}
