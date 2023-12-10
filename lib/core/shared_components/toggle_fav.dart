import 'package:flutter/material.dart';
import 'package:motors_app/core/styles/styles.dart';

class ToggleFavouriteProvider extends ChangeNotifier {
  bool _isFav = false;
  Color? _favColor;

  Color? get favColor => _favColor;

  set setColor(Color color) => _favColor = color;

  bool? get isFav => _isFav;

  set setFav(bool value) => _isFav = value;

  void toggle() {
    _favColor = _isFav ? Colors.grey : mainColor;
    _isFav = _isFav ? false : true;
    notifyListeners();
  }
}
