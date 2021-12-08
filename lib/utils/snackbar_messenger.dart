import 'package:flutter/material.dart';

class SnackBarMessenger {
  SnackBarMessenger._internal();

  static void showInfo(BuildContext context, String message) {
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    scaffoldMessengerState.hideCurrentSnackBar();
    scaffoldMessengerState.showSnackBar(
      SnackBar(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          label: "Dismiss",
          textColor: Colors.yellow,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    scaffoldMessengerState.hideCurrentSnackBar();
    scaffoldMessengerState.showSnackBar(
      SnackBar(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          label: "Dismiss",
          textColor: Colors.yellow,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        backgroundColor: Colors.greenAccent.shade700,
      ),
    );
  }

  static void showWarning(BuildContext context, String message) {
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    scaffoldMessengerState.hideCurrentSnackBar();
    scaffoldMessengerState.showSnackBar(
      SnackBar(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          label: "Dismiss",
          textColor: Colors.yellow,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        backgroundColor: Colors.orangeAccent.shade400,
      ),
    );
  }

  static void showDanger(BuildContext context, String message) {
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    scaffoldMessengerState.hideCurrentSnackBar();
    scaffoldMessengerState.showSnackBar(
      SnackBar(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          label: "Dismiss",
          textColor: Colors.yellow,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        backgroundColor: Colors.redAccent.shade400,
      ),
    );
  }
}
