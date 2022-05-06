import 'package:bot_toast/bot_toast.dart';
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

  static void showLoading({
    required String title,
    required Future<void> Function() future,
  }) {
    future().then((value) => BotToast.closeAllLoading());
    BotToast.showLoading();
  }

  static AlertDialog buildLoadingDialog(Future<void> Function() future, BuildContext context, String title) {
    future().then((value) => Navigator.of(context).maybePop());
    return AlertDialog(
      title: Text(title),
      content: const CircularProgressIndicator.adaptive(),
    );
  }
}
