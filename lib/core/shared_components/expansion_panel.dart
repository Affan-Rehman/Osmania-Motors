import 'package:flutter/cupertino.dart';

class ExpansionPanelProvider extends ChangeNotifier {
  bool isExpandedFeatures = true;
  bool isExpandedComments = true;
  bool isExpandedLocation = true;

  void toggleExpansionFeatures() {
    isExpandedFeatures = !isExpandedFeatures;
    notifyListeners();
  }

  void toggleExpansionComment() {
    isExpandedComments = !isExpandedComments;
    notifyListeners();
  }

  void toggleExpansionLocation() {
    isExpandedLocation = !isExpandedLocation;
    notifyListeners();
  }
}
