import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
UserAuthFailedDialogBox(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Expanded(
        child: AlertDialog(
          //title: Text('Welcome'),
          content: Text(message),
          actions: [
            Container(
              height: 40,
              width: 80,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                )),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blue, Colors.cyan, Colors.blue]),
                  ),
                  child: Container(
                    child: const Text(
                      'Ok',
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
