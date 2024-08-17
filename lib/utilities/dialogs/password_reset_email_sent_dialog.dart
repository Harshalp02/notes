import 'package:flutter/material.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordRestResendDialog(BuildContext context) {
  return showGenericDialog<void>(
      context: context,
      title: 'Password Reset',
      content:
          'we have now sent you a password reset link. Please check your email for more imformation.',
      optionBuilder: () => {'OK': null});
}
