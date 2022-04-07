import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String error) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('An error occurred', style: TextStyle(fontWeight: FontWeight.bold),),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      }
  );
}