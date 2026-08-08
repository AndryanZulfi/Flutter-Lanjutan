import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void addCounter() => state++;

  void minCounter() => state--;
}

final counterProvider = NotifierProvider<CounterNotifier, int>(CounterNotifier.new);
