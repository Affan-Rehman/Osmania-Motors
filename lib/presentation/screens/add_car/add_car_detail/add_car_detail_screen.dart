import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:line_icons/line_icon.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/presentation/bloc/add_car/add_car_bloc.dart';
import 'package:motors_app/presentation/screens/add_car/add_car_screen.dart';
import 'package:motors_app/presentation/screens/add_car/chooseSerie.dart';
import 'package:motors_app/presentation/screens/add_car/chooseVariant.dart';
import 'package:motors_app/presentation/screens/add_car/chooseYear.dart';
import 'package:motors_app/presentation/screens/main_screens.dart';
import 'package:motors_app/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AddCarDetailScreen extends StatefulWidget {
  AddCarDetailScreen({Key? key, this.addType, this.data}) : super(key: key);
  final dynamic addType;
  List<dynamic>? data;
  static var EditData;
  static var PostID;
  static var isEdit;
  static getEditData(value) {
    EditData = value;
  }

  static getPostID(value) {
    PostID = value;
  }

  static getIsEdit(value) {
    isEdit = value;
  }

  @override
  State<AddCarDetailScreen> createState() => _AddCarDetailScreenState();
}

class _AddCarDetailScreenState extends State<AddCarDetailScreen> {
  List<dynamic> filterListSeries = [];
  List<dynamic> filterListVariants = [];
  TextEditingController MakessearchController = TextEditingController();
  TextEditingController ModelsSearchController = TextEditingController();
  TextEditingController YearSearchController = TextEditingController();
  TextEditingController GenericSearchController = TextEditingController();
  List? filteredCarMakes = [];
  List? filteredCarModels = [];
  List? filteredYear = [];
  List? filteredData = [];

  Future filterList() async {
    if (widget.addType == 'serie') {
      //Проверка на марку машины, если марка машины BMW то модели будут только BMW(bmw m5 и т.д, не будет других, проверка по параметру parent)
      for (var element in widget.data!) {
        if (Provider.of<AddCarFunctions>(context, listen: false)
            .addCarMap
            .containsKey('make')) {
          Provider.of<AddCarFunctions>(context, listen: false)
              .addCarMap['make']
              .forEach((key, value) {
            if (element['parent'] == key) {
              setState(() {
                filterListSeries.add(element);
              });
            }
          });
        }
      }
    }
  }

  Future filterVariants() async {
    if (widget.addType == 'variation') {
      //Проверка на марку машины, если марка машины BMW то модели будут только BMW(bmw m5 и т.д, не будет других, проверка по параметру parent)
      for (var element in widget.data!) {
        if (Provider.of<AddCarFunctions>(context, listen: false)
            .addCarMap
            .containsKey('serie')) {
          Provider.of<AddCarFunctions>(context, listen: false)
              .addCarMap['serie']
              .forEach((key, value) {
            if (element['parent'] == key) {
              setState(() {
                filterListVariants.add(element);
              });
            }
          });
        }
      }
    }
  }

  @override
  void initState() {
    if (widget.addType == 'serie') {
      filterList().then((value) {
        if (filterListSeries.isNotEmpty) {
          setState(() {
            widget.data = filterListSeries;
          });
        }
      });
    }
    if (widget.addType == 'variation') {
      filterVariants().then((value) {
        if (filterListVariants.isNotEmpty) {
          setState(() {
            widget.data = filterListVariants;
          });
        }
      });
    }

    List<String> sequence = [
      'toyota',
      'suzuki',
      'honda',
      'daihatsu',
      'kia',
      'nissan',
      'hyundai',
      'mitsubishi',
      'changan',
      'mercedes',
      'mg',
      'faw',
      'audi',
      'bmw',
      'prince',
      'mazda',
    ];
    if (widget.data != null) if (widget.addType != 'year')
      widget.data!.sort((a, b) {
        try {
          int indexA = sequence.indexOf(a['slug']);
          int indexB = sequence.indexOf(b['slug']);
          if (indexA == -1 && indexB == -1) {
            return 0; // Both slugs are unknown, maintain the order
          } else if (indexA == -1) {
            return 1; // Unknown slug comes after known slug
          } else if (indexB == -1) {
            return -1; // Known slug comes before unknown slug
          } else {
            return indexA.compareTo(indexB); // Compare known slugs
          }
        } catch (e) {
          int indexA = sequence.indexOf(a.GetSlug);
          int indexB = sequence.indexOf(b.GetSlug);
          if (indexA == -1 && indexB == -1) {
            return 0; // Both slugs are unknown, maintain the order
          } else if (indexA == -1) {
            return 1; // Unknown slug comes after known slug
          } else if (indexB == -1) {
            return -1; // Known slug comes before unknown slug
          } else {
            return indexA.compareTo(indexB); // Compare known slugs
          }
        }
      });
    else
      widget.data!.sort((a, b) => a['value'].compareTo(b['value']));

    if (widget.addType == 'make') {
      filteredCarMakes = widget.data;
      MakessearchController.addListener(() {
        filterCarMakes(MakessearchController.text);
      });
    }
    if (widget.addType == 'serie') {
      filteredCarModels = filterListSeries;
      ModelsSearchController.addListener(() {
        filterCarModels(ModelsSearchController.text);
      });
    }
    if (widget.addType == 'year') {
      filteredYear = widget.data;
      YearSearchController.addListener(() {
        filterYear(YearSearchController.text);
      });
    }
    if (widget.addType == 'variation') {
      filteredData = filterListVariants;
      GenericSearchController.addListener(() {
        filterData(GenericSearchController.text);
      });
    }
    if (widget.addType == 'exterior-color' ||
        widget.addType == 'registered-in' ||
        widget.addType == 'transmission') {
      filteredData = widget.data;
      print(filteredData);
      GenericSearchController.addListener(() {
        filterData(GenericSearchController.text);
      });
    }

    super.initState();
  }

  void filterData(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredData = widget.data;
      });
    } else {
      setState(() {
        filteredData = widget.data!.where((data) {
          return data['label'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void filterYear(String query) {
    print('filter year called');
    if (query.isEmpty) {
      setState(() {
        filteredYear = widget.data;
      });
    } else {
      setState(() {
        print('filter year 2 called');
        print(filteredYear!.length);
        filteredYear = widget.data!.where((year) {
          return year['label'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void filterCarMakes(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredCarMakes = widget.data;
      });
    } else {
      setState(() {
        filteredCarMakes = widget.data!.where((carMake) {
          return carMake.label.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void filterCarModels(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredCarModels = filterListSeries;
      });
    } else {
      setState(() {
        filteredCarModels = widget.data!.where((model) {
          return model['label'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red,
        title: Text(
          widget.addType == 'make'
              ? translations!['choose_make']
              : widget.addType == 'serie'
                  ? translations!['choose_model']
                  : widget.addType == 'year'
                      ? '${translations!['choose']} ${translations!['year']}'
                      : widget.addType == 'exterior-color'
                          ? '${translations!['choose']} ${translations!['exterior-color']}'
                          : translations!['choose'],
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        leading: AppBarIcon(
          iconData: Icons.arrow_back_outlined,
          borderColor: white,
          iconColor: white,
          onTap: () {
            // if (widget.addType != 'make') {
            //   Navigator.push(context, MaterialPageRoute(builder: (context) {
            //     return AddCarDetailScreensTwo();
            //   }));
            // } else {
            //   Navigator.pop(context);
            // }
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MainScreen(
                  selectedIndex: 0,
                ),
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: [
              Expanded(
                child: widget.addType == 'make'
                    ? Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(
                                    0,
                                    3,
                                  ), // changes position of shadow
                                ),
                              ],
                            ),
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: MakessearchController,
                              decoration: InputDecoration(
                                hintText: 'Search Makes...',
                                border: InputBorder.none,
                                prefixIcon: LineIcon.moon(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: AlignedGridView.count(
                              itemCount: filteredCarMakes!.length ?? 0,
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                              itemBuilder: (context, index) {
                                var el = filteredCarMakes![
                                    index]; //widget.data![index];
                                bool isSelected = false;

                                if (Provider.of<AddCarFunctions>(
                                  context,
                                  listen: false,
                                ).addCarMap.containsKey(widget.addType)) {
                                  try {
                                    if (Provider.of<AddCarFunctions>(
                                          context,
                                          listen: false,
                                        )
                                            .addCarMap[widget.addType]
                                            .values
                                            .toString()
                                            .substring(
                                              1,
                                              Provider.of<AddCarFunctions>(
                                                    context,
                                                    listen: false,
                                                  )
                                                      .addCarMap[widget.addType]
                                                      .values
                                                      .toString()
                                                      .length -
                                                  1,
                                            ) ==
                                        el.GetLabel) {
                                      isSelected = true;
                                    }
                                  } catch (e) {
                                    if (Provider.of<AddCarFunctions>(
                                          context,
                                          listen: false,
                                        )
                                            .addCarMap[widget.addType]
                                            .values
                                            .toString()
                                            .substring(
                                              1,
                                              Provider.of<AddCarFunctions>(
                                                    context,
                                                    listen: false,
                                                  )
                                                      .addCarMap[widget.addType]
                                                      .values
                                                      .toString()
                                                      .length -
                                                  1,
                                            ) ==
                                        el['label']) {
                                      isSelected = true;
                                    }
                                  }
                                }

                                return GestureDetector(
                                  onTap: () {
                                    clickedMe(el);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChooseSerie(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 200,
                                    margin: const EdgeInsets.only(
                                      bottom: 10,
                                      top: 10,
                                      right: 10,
                                      left: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      border: Border.all(
                                        color: isSelected
                                            ? mainColor
                                            : Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: getColumn(el),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : widget.addType == 'serie'
                        ? Container(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: Offset(
                                          0,
                                          3,
                                        ), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    controller: ModelsSearchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search Models...',
                                      border: InputBorder.none,
                                      prefixIcon: LineIcon.moon(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    primary: true,
                                    shrinkWrap: true,
                                    key: UniqueKey(),
                                    itemCount: filteredCarModels!.length,
                                    itemBuilder: (BuildContext ctx, int index) {
                                      var el = filteredCarModels![index];

                                      bool isSelected = false;

                                      if (Provider.of<AddCarFunctions>(
                                        context,
                                        listen: false,
                                      ).addCarMap.containsKey(widget.addType)) {
                                        if (Provider.of<AddCarFunctions>(
                                              context,
                                              listen: false,
                                            )
                                                .addCarMap[widget.addType]
                                                .values
                                                .toString()
                                                .substring(
                                                  1,
                                                  Provider.of<AddCarFunctions>(
                                                        context,
                                                        listen: false,
                                                      )
                                                          .addCarMap[
                                                              widget.addType]
                                                          .values
                                                          .toString()
                                                          .length -
                                                      1,
                                                ) ==
                                            el['label']) {
                                          isSelected = true;
                                        }
                                      }

                                      return GestureDetector(
                                        onTap: () {
                                          Provider.of<AddCarFunctions>(
                                            context,
                                            listen: false,
                                          ).addCarParams(
                                            type: widget.addType,
                                            element: {el['slug']: el['label']},
                                          );

                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChooseVariant(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
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
                                                el['label'],
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
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : widget.addType == 'variation'
                            ? Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                          offset: Offset(
                                            0,
                                            3,
                                          ), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      controller: GenericSearchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search Variants...',
                                        border: InputBorder.none,
                                        prefixIcon: LineIcon.moon(
                                          color: red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: filteredData!.length ?? 0,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        var el = filteredData![index];
                                        bool isSelected = false;

                                        if (Provider.of<AddCarFunctions>(
                                          context,
                                          listen: false,
                                        )
                                            .addCarMap
                                            .containsKey(widget.addType)) {
                                          if (Provider.of<AddCarFunctions>(
                                                context,
                                                listen: false,
                                              )
                                                  .addCarMap[widget.addType]
                                                  .values
                                                  .toString()
                                                  .substring(
                                                    1,
                                                    Provider.of<
                                                                AddCarFunctions>(
                                                          context,
                                                          listen: false,
                                                        )
                                                            .addCarMap[
                                                                widget.addType]
                                                            .values
                                                            .toString()
                                                            .length -
                                                        1,
                                                  ) ==
                                              el['label']) {
                                            isSelected = true;
                                          }
                                        }

                                        return GestureDetector(
                                          onTap: () {
                                            Provider.of<AddCarFunctions>(
                                              context,
                                              listen: false,
                                            ).addCarParams(
                                              type: widget.addType,
                                              element: {
                                                el['slug']: el['label'],
                                              },
                                            );

                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChooseYear(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              border: Border.all(
                                                color: isSelected
                                                    ? mainColor
                                                    : const Color(0xffe9eef0),
                                                width: 2,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  el['label'],
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
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : widget.addType == 'year'
                                ? Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 3,
                                              blurRadius: 5,
                                              offset: Offset(
                                                0,
                                                3,
                                              ), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          controller: YearSearchController,
                                          decoration: InputDecoration(
                                            hintText: 'Search Year...',
                                            border: InputBorder.none,
                                            prefixIcon: LineIcon.moon(
                                              color: red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: filteredYear!.length ?? 0,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            var el = filteredYear![index];
                                            bool isSelected = false;

                                            if (Provider.of<AddCarFunctions>(
                                              context,
                                              listen: false,
                                            ).addCarMap.containsKey(
                                                  widget.addType,
                                                )) {
                                              if (Provider.of<AddCarFunctions>(
                                                    context,
                                                    listen: false,
                                                  )
                                                      .addCarMap[widget.addType]
                                                      .values
                                                      .toString()
                                                      .substring(
                                                        1,
                                                        Provider.of<
                                                                    AddCarFunctions>(
                                                              context,
                                                              listen: false,
                                                            )
                                                                .addCarMap[widget
                                                                    .addType]
                                                                .values
                                                                .toString()
                                                                .length -
                                                            1,
                                                      ) ==
                                                  el['label']) {
                                                isSelected = true;
                                              }
                                            }

                                            return GestureDetector(
                                              onTap: () {
                                                Provider.of<AddCarFunctions>(
                                                  context,
                                                  listen: false,
                                                ).addCarParams(
                                                  type: widget.addType,
                                                  element: {
                                                    el['slug']: el['label'],
                                                  },
                                                );

                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddCarScreen(
                                                      isEdit: AddCarDetailScreen
                                                          .isEdit,
                                                      postId: AddCarDetailScreen
                                                          .PostID,
                                                      editData:
                                                          AddCarDetailScreen
                                                              .EditData,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? mainColor
                                                        : const Color(
                                                            0xffe9eef0,
                                                          ),
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      el['label'],
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: secondaryColor,
                                                      ),
                                                    ),
                                                    isSelected
                                                        ? Icon(
                                                            IconsMotors.check,
                                                            color: mainColor,
                                                            size: 18,
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : widget.addType == 'body'
                                    ? Container(
                                        child: Column(
                                          children: [
                                            ListView.builder(
                                              primary: false,
                                              shrinkWrap: true,
                                              key: UniqueKey(),
                                              itemCount: widget.data!.length,
                                              itemBuilder: (
                                                BuildContext ctx,
                                                int index,
                                              ) {
                                                var el = widget.data![index];

                                                bool isSelected = false;

                                                if (Provider.of<
                                                        AddCarFunctions>(
                                                  context,
                                                  listen: false,
                                                ).addCarMap.containsKey(
                                                      widget.addType,
                                                    )) {
                                                  if (Provider.of<
                                                              AddCarFunctions>(
                                                        context,
                                                        listen: false,
                                                      )
                                                          .addCarMap[
                                                              widget.addType]
                                                          .values
                                                          .toString()
                                                          .substring(
                                                            1,
                                                            Provider.of<
                                                                        AddCarFunctions>(
                                                                  context,
                                                                  listen: false,
                                                                )
                                                                    .addCarMap[
                                                                        widget
                                                                            .addType]
                                                                    .values
                                                                    .toString()
                                                                    .length -
                                                                1,
                                                          ) ==
                                                      el.label) {
                                                    isSelected = true;
                                                  }
                                                }

                                                return GestureDetector(
                                                  onTap: () {
                                                    Provider.of<
                                                        AddCarFunctions>(
                                                      context,
                                                      listen: false,
                                                    ).addCarParams(
                                                      type: widget.addType,
                                                      element: {
                                                        el['slug']: el.label,
                                                      },
                                                    );

                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddCarScreen(
                                                          isEdit:
                                                              AddCarDetailScreen
                                                                  .isEdit,
                                                          postId:
                                                              AddCarDetailScreen
                                                                  .PostID,
                                                          editData:
                                                              AddCarDetailScreen
                                                                  .EditData,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 10,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(
                                                      12,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(10),
                                                      ),
                                                      border: Border.all(
                                                        color: isSelected
                                                            ? mainColor
                                                            : const Color(
                                                                0xffe9eef0,
                                                              ),
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          el.label,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                secondaryColor,
                                                          ),
                                                        ),
                                                        isSelected
                                                            ? Icon(
                                                                IconsMotors
                                                                    .check,
                                                                color:
                                                                    mainColor,
                                                                size: 18,
                                                              )
                                                            : const SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextField(
                                              controller:
                                                  GenericSearchController,
                                              decoration: InputDecoration(
                                                labelText: 'Search ',
                                                prefixIcon: Icon(Icons.search),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              primary: true,
                                              itemCount:
                                                  filteredData!.length ?? 0,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                var el = filteredData![index];
                                                bool isSelected = false;

                                                if (Provider.of<
                                                        AddCarFunctions>(
                                                  context,
                                                  listen: false,
                                                ).addCarMap.containsKey(
                                                      widget.addType,
                                                    )) {
                                                  if (Provider.of<
                                                              AddCarFunctions>(
                                                        context,
                                                        listen: false,
                                                      )
                                                          .addCarMap[
                                                              widget.addType]
                                                          .values
                                                          .toString()
                                                          .substring(
                                                            1,
                                                            Provider.of<
                                                                        AddCarFunctions>(
                                                                  context,
                                                                  listen: false,
                                                                )
                                                                    .addCarMap[
                                                                        widget
                                                                            .addType]
                                                                    .values
                                                                    .toString()
                                                                    .length -
                                                                1,
                                                          ) ==
                                                      el['label']) {
                                                    isSelected = true;
                                                  }
                                                }

                                                return GestureDetector(
                                                  onTap: () {
                                                    Provider.of<
                                                        AddCarFunctions>(
                                                      context,
                                                      listen: false,
                                                    ).addCarParams(
                                                      type: widget.addType,
                                                      element: {
                                                        el['slug']: el['label'],
                                                      },
                                                    );

                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 10,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(
                                                      12,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(10),
                                                      ),
                                                      border: Border.all(
                                                        color: isSelected
                                                            ? mainColor
                                                            : const Color(
                                                                0xffe9eef0,
                                                              ),
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          el['label'],
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                secondaryColor,
                                                          ),
                                                        ),
                                                        isSelected
                                                            ? Icon(
                                                                IconsMotors
                                                                    .check,
                                                                color:
                                                                    mainColor,
                                                                size: 18,
                                                              )
                                                            : const SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getColumn(el) {
    try {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Image(
              image: NetworkImage(el.GetURL),
            ),
          ),
          Text(
            el.GetLabel,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
      );
    } catch (e) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Image(
              image: NetworkImage(el['logo']),
            ),
          ),
          Text(
            el['label'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
      );
    }
  }

  clickedMe(el) {
    try {
      Provider.of<AddCarFunctions>(
        context,
        listen: false,
      ).addCarParams(
        type: widget.addType,
        element: {el.GetSlug: el.GetLabel},
      );
    } catch (e) {
      Provider.of<AddCarFunctions>(
        context,
        listen: false,
      ).addCarParams(
        type: widget.addType,
        element: {el['slug']: el['label']},
      );
    }
  }

  @override
  void dispose() {
    YearSearchController.clear();
    MakessearchController.clear();
    ModelsSearchController.clear();
    super.dispose();
  }
}
