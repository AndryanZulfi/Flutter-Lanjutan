import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/riverpod/counter_notifier.dart';
import 'package:state_management/riverpod/theme_notifier.dart';

class CounterRiverpodScreen extends ConsumerWidget {
  const CounterRiverpodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Row(
          spacing: 32.0,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buttonIncrement(ref),
            _textCounter(ref),
            _buttonDecrement(ref),
          ],
        ),
      ),
    );
  }

    Widget _buttonIncrement(WidgetRef ref) {
    return FilledButton(
      onPressed: () {
        ref.read(counterProvider.notifier).addCounter();
        ref.read(themeProvider.notifier).changeTextColor(ref.read(counterProvider));
      },
      child: const Text("+"),
    );
  }

  Widget _buttonDecrement(WidgetRef ref) {
    return FilledButton(
      onPressed: () {
        ref.read(counterProvider.notifier).minCounter();
        ref.read(themeProvider.notifier).changeTextColor(ref.read(counterProvider));
      },
      child: const Text("-"),
    );
  }

  Widget _textCounter(WidgetRef ref) {
    return Consumer(
      builder: (context, widgetRef, child){
        final counter = widgetRef.watch(counterProvider);
        final theme = widgetRef.watch(themeProvider);
        return Text(
          '$counter',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: theme
          ),
      );
    });
  }

}