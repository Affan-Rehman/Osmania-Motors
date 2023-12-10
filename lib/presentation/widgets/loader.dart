import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Center(
        child:
            LoadingAnimationWidget.halfTriangleDot(color: Colors.red, size: 60),
      );
    } else {
      return Center(
        child:
            LoadingAnimationWidget.halfTriangleDot(color: Colors.red, size: 60),
      );
    }
  }
}
