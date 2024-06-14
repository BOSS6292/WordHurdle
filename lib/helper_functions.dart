import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showMsg(BuildContext context, String msg){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
          msg)));
}

void showResults({
  required BuildContext context,
  required String title,
  required String body,
  required VoidCallback onCancel,
  required VoidCallback onPlayAgain,
}) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(
                onPressed: onCancel,
                child: const Text('QUIT'),
              ),
              TextButton(
                onPressed: onPlayAgain,
                child: const Text('PLAY AGAIN'),
              )
            ],
          ));
}
