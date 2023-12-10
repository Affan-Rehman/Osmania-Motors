import 'package:flutter/cupertino.dart';
import 'package:motors_app/core/env.dart';

class SearchFilterProvider extends ChangeNotifier {
  String from = translations!['from'] ?? 'From';
  String to = translations!['to'] ?? 'To';

  Map<String, List<dynamic>> selectedSearchFilterList = {};

  set setValueFrom(value) => from = value;

  set setValueTo(value) => to = value;

  set clearSelectedSearchFilterList(value) => selectedSearchFilterList = value;

  void selectedFilterValue({typeKey, value, selectedValue}) {
    if (!selectedSearchFilterList.containsKey(typeKey)) {
      selectedValue.add(value);

      selectedSearchFilterList[typeKey] = selectedValue;
    } else {
      if (selectedSearchFilterList.isEmpty) {
        selectedSearchFilterList[typeKey] = selectedValue;

        selectedValue.add(value);
      } else if (!selectedSearchFilterList[typeKey]!.contains(value)) {
        selectedSearchFilterList[typeKey] = selectedValue;

        selectedValue.add(value);
      } else {
        selectedSearchFilterList[typeKey]!.removeWhere((element) => element == value);
      }
    }
    notifyListeners();
  }

  void removeElement({typeKey, el}) {
    selectedSearchFilterList[typeKey]!.removeWhere((element) => element == el);
    notifyListeners();
  }

  void toggleFrom(value) {
    from = value;
    notifyListeners();
  }

  void toggleTo(value) {
    to = value;
    notifyListeners();
  }
}
