import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:state_management/provider/counter_provider.dart';
import 'package:state_management/provider/theme_provider.dart';
import 'package:state_management/screen/counter_provider_screen.dart';
import 'package:state_management/screen/counter_riverpod_screen.dart';

void main() {
  // runApp(const MyApp());

  //PROVIDER
  // runApp(
  //   MultiProvider(providers: [
  //     ChangeNotifierProvider(create: (context) => CounterModel()),
  //     ChangeNotifierProvider(create: (context) => ThemeModel())
  //   ],
  //   child: MyApp(),)
  // );

  //PRIVERPOD
  runApp(
    ProviderScope(
      child: MyApp() 
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
    
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const CounterRiverpodScreen(),
    );
  }
}
