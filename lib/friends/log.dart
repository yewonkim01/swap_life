import 'dart:developer' as developer;
import 'package:flutter/material.dart';

class Log{
  static void i(BuildContext context, String tag, String msg, [Object? error]){
    var message = (error == null) ? msg : "${msg}\n${error}";
    developer.log(message, name: tag, level: 3); //정보성 로그
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  static void d(BuildContext context, String tag, String msg){
    developer.log(msg, name: tag, level: 2); //디버깅용 로그
  }

  static void e(BuildContext context, String tag, String msg, [Object? error]){
    var message = (error == null) ? msg : "${msg}\n${error}";
    developer.log(message, name: tag, level: 5); //문제 발생시 로그
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}