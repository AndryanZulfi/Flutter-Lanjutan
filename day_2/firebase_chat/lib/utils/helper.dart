import 'package:flutter/material.dart';

class Helper{

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