import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/provider/counter_provider.dart';
import 'package:state_management/provider/theme_provider.dart';

class CounterProviderScreen extends StatefulWidget {
  const CounterProviderScreen({super.key});

  @override
  State<CounterProviderScreen> createState() => _CounterProviderScreenState();
}

class _CounterProviderScreenState extends State<CounterProviderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          spacing: 32.0,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buttonIncrement(context),
            _textCounter(),
            _buttonDecrement(context),
          ],
        ),
      ),
    );
  }

  Widget _buttonIncrement(BuildContext context) {
    final themeModel = context.read<ThemeModel>();
    return FilledButton(
      onPressed: () {
        context.read<CounterModel>().addCounter();
        themeModel.changeTextColor(context.read<CounterModel>().counter);
      },
      child: const Text("+"),
    );
  }

  Widget _buttonDecrement(BuildContext context) {
    final themeModel = context.read<ThemeModel>();
    return FilledButton(
      onPressed: () {
        context.read<CounterModel>().minCounter();
        themeModel.changeTextColor(context.read<CounterModel>().counter);
      },
      child: const Text("-"),
    );
  }

  Widget _textCounter() {
    return Selector2<CounterModel, ThemeModel, (int, Color)>(
      selector: (context, counterModel, themeModel) => (counterModel.counter, themeModel.textColor),
      builder: (context, tuple, child) {
        return Text(
          '${tuple.$1}',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: tuple.$2
          ),
        );
      },
    );
  }
}