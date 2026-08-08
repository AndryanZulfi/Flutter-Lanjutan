import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/auth/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/list/list_item_provider.dart';
import 'screens/list/list_item_screen.dart';
import 'services/auth_service.dart';
import 'services/item_service.dart';
import 'utils/helper.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(AuthService()),
        ),
        ChangeNotifierProvider(
          create: (context) => ListItemProvider(ItemService()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

Future<bool> checkIsLogin() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(Helper.IS_LOGIN) ?? false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder<bool>(
        future: checkIsLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const ListItemScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
