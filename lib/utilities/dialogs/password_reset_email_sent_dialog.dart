import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password reset',
    content: "We've sent you a password reset link, please check your email",
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
