import 'package:flutter/material.dart';

class Helper {

  static const NEED_REFRESH = true;

  static void showSnackbar(BuildContext context, String message, {Color bgColor = Colors.red}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
      )
    );
  }

}