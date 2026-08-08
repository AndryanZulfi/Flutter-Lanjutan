import 'package:flutter/material.dart';

class Helper{

  static const String TOKEN = "token";
  static const String IS_LOGIN = "isLogin";

  static void showSnackBar(BuildContext context, String message, {Color color = Colors.red}){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        )
    );
  }

}
