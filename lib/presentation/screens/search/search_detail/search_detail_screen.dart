import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/shared_components/components.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SearchDetailScreen extends StatefulWidget {
  SearchDetailScreen({Key? key, this.typeSearch, this.typeKey})
      : super(key: key);
  static const routeName = 'searchDetailScreen';
  List<dynamic>? typeSearch;
  final dynamic typeKey;

  @override
  State<SearchDetailScreen> createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends State<SearchDetailScreen> {
  TextEditingController searchController = TextEditingController();
  String? headerText = '';
  List<dynamic> filteredSearch = [];
  List<dynamic> selectedValue = [];
  List<dynamic> filterListSeries = [];

  Future filterList() async {
    if (widget.typeKey == 'serie') {
      for (var element in widget.typeSearch!) {
        for (var el in Provider.of<SearchFilterProvider>(context, listen: false)
            .selectedSearchFilterList['make']!) {
          if (element['parent'] == el['slug']) {
            filterListSeries.add(element);
          }
        }
      }
    }
  }

  @override
  void initState() {
    if (widget.typeKey != null || widget.typeKey != '') {
      // ignore: prefer_interpolation_to_compose_strings
      headerText = translations!['choose_' + widget.typeKey];
    }

    if (Provider.of<SearchFilterProvider>(context, listen: false)
        .selectedSearchFilterList
        .containsKey('make')) {
      if (Provider.of<SearchFilterProvider>(context, listen: false)
          .selectedSearchFilterList['make']!
          .isNotEmpty) {
        if (widget.typeKey == 'serie') {
          filterList().then((value) {
            setState(() {
              widget.typeSearch = filterListSeries;
            });
          });
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          headerText == null
              ? translations!['choose'] ?? 'Choose'
              : headerText!,
          style: TextStyle(
            color: grey88,
            fontSize: 14,
          ),
        ),
        leading: AppBarIcon(
          iconData: IconsMotors.arrow_back,
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: [
              //Search Field
              Visibility(
                visible: widget.typeKey == 'make' ? false : true,
                child: SizedBox(
                  height: 45,
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (val) {
                      for (int i = 0; i < widget.typeSearch!.length; i++) {
                        var data = widget.typeSearch;
                        if (data?[i]['label']
                                .toLowerCase()
                                .contains(val.toLowerCase()) ||
                            data?[i]['label']
                                .toUpperCase()
                                .contains(val.toUpperCase())) {
                          filteredSearch.clear();
                          setState(() {
                            filteredSearch.add(data![i]);
                          });
                        }
                      }

                      if (val.isEmpty) {
                        filteredSearch.clear();
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffe9eef0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 0, color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintStyle: TextStyle(color: grey1, fontSize: 13),
                      hintText:
                          translations!['type_for_search'] ?? 'Type for search',
                    ),
                  ),
                ),
              ),
              //Details
              Expanded(
                child: widget.typeKey == 'make'
                    ? AlignedGridView.count(
                        itemCount: widget.typeSearch?.length ?? 0,
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        itemBuilder: (context, index) {
                          var item = widget.typeSearch?[index];
                          bool isSelected = false;

                          if (Provider.of<SearchFilterProvider>(context)
                              .selectedSearchFilterList
                              .isEmpty) {
                            isSelected = false;
                          } else {
                            if (Provider.of<SearchFilterProvider>(context)
                                    .selectedSearchFilterList[widget.typeKey] ==
                                null) {
                            } else {
                              for (var element in Provider.of<
                                      SearchFilterProvider>(context)
                                  .selectedSearchFilterList[widget.typeKey]!) {
                                if (item['label'] == element['label']) {
                                  isSelected = true;
                                }
                              }
                            }
                          }

                          return GestureDetector(
                            onTap: () => Provider.of<SearchFilterProvider>(
                                    context,
                                    listen: false)
                                .selectedFilterValue(
                              typeKey: widget.typeKey,
                              value: item,
                              selectedValue: selectedValue,
                            ),
                            child: Container(
                              width: 100,
                              height: 200,
                              margin: const EdgeInsets.only(
                                  bottom: 10, top: 10, right: 10, left: 10),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: isSelected ? mainColor : Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    child: Image(
                                      image: NetworkImage(item['logo']),
                                    ),
                                  ),
                                  Text(
                                    item['label'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        primary: true,
                        key: UniqueKey(),
                        itemCount: filteredSearch.isNotEmpty
                            ? filteredSearch.length
                            : widget.typeSearch?.length ?? 0,
                        itemBuilder: (BuildContext ctx, int index) {
                          bool isSelected = false;
                          var item;
                          if (filteredSearch.isNotEmpty) {
                            item = filteredSearch[index];
                          } else {
                            item = widget.typeSearch?[index];
                          }

                          if (Provider.of<SearchFilterProvider>(context)
                              .selectedSearchFilterList
                              .isEmpty) {
                            isSelected = false;
                          } else {
                            if (Provider.of<SearchFilterProvider>(context)
                                    .selectedSearchFilterList[widget.typeKey] ==
                                null) {
                            } else {
                              for (var element in Provider.of<
                                      SearchFilterProvider>(context)
                                  .selectedSearchFilterList[widget.typeKey]!) {
                                if (item['label'] == element['label']) {
                                  isSelected = true;
                                }
                              }
                            }
                          }

                          return GestureDetector(
                            onTap: () => Provider.of<SearchFilterProvider>(
                                    context,
                                    listen: false)
                                .selectedFilterValue(
                              typeKey: widget.typeKey,
                              value: item,
                              selectedValue: selectedValue,
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: isSelected
                                      ? mainColor
                                      : const Color(0xffe9eef0),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item['label'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: secondaryColor,
                                    ),
                                  ),
                                  isSelected
                                      ? Icon(
                                          IconsMotors.check,
                                          color: mainColor,
                                          size: 18,
                                        )
                                      : Text(
                                          item['count'].toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: grey1,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              //Choose Button
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(secondaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        IconsMotors.searchLight,
                        size: 15,
                      ),
                      const SizedBox(width: 8),
                      Text(headerText != null
                          ? headerText!
                          : translations?['choose'] ?? 'Choose'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
