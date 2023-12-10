import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

cupertinoAlertDialog({context, title, content, submitText, cancelText, required VoidCallback onPressedYes, required VoidCallback onPressedNo}) {
  return showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: onPressedNo,
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: onPressedYes,
            child: Text(submitText),
          )
        ],
      );
    },
  );
}

materialAlertDialog({context, title, content, submitText, cancelText, required VoidCallback onPressedYes, required VoidCallback onPressedNo}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(onPressed: onPressedNo, child: Text(cancelText)),
          TextButton(
            onPressed: onPressedYes,
            child: Text(submitText),
          )
        ],
      );
    },
  );
}
