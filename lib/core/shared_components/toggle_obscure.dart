import 'package:flutter/cupertino.dart';

class ToggleObscure extends ChangeNotifier {
  bool isObscure = true;
  bool isObscureSingUp = true;
  bool isObscureEditProfile = true;

  void toggle() {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future<bool> toggleSignUp() async {
    isObscureSingUp = !isObscureSingUp;
    notifyListeners();
    return isObscureSingUp;
  }

  void toggleEditProfile() {
    isObscureEditProfile = !isObscureEditProfile;
    notifyListeners();
  }

}
