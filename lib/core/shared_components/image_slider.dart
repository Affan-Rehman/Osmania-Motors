import 'package:flutter/cupertino.dart';

class ImageSliderProvider extends ChangeNotifier {
  int currentImgPage = 1;
  int currentBottomSheetPage = 1;


  void onPageViewChange(int index) {
    currentImgPage = index + 1;
    notifyListeners();
  }

  void onPageViewChangeFullScreen(int index) {
    currentBottomSheetPage = index + 1;
    notifyListeners();
  }
}
