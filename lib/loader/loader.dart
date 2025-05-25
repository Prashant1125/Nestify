import 'package:flutter/material.dart';

class LoadingDialog {
  static bool _isShowing = false;

  static void show(BuildContext context) {
    if (_isShowing) return; // Prevent multiple dialogs
    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false, // Prevent back button closing
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
                child: LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.tealAccent),
              minHeight: 5,
            )),
          ),
        );
      },
    ).then((_) => _isShowing = false);
  }

  static void hide(BuildContext context) {
    if (_isShowing && Navigator.canPop(context)) {
      _isShowing = false;
      Navigator.of(context).pop();
    }
  }
}
