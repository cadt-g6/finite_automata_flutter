import 'package:flutter/material.dart';

class ToastService {
  static void showSnackbar({
    required BuildContext context,
    required String title,
    bool error = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: !error ? null : Theme.of(context).colorScheme.error,
      content: Text(
        title,
        style: TextStyle(color: !error ? null : Theme.of(context).colorScheme.onError),
      ),
    ));
  }
}
