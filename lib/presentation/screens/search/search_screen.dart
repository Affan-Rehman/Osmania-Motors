import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/shared_components/components.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/presentation/bloc/filter/filter_bloc.dart';
import 'package:motors_app/presentation/screens/screens.dart';
import 'package:motors_app/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  static const routeName = '/search_screen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late FilterBloc filterBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  double sliderKm = 1000;
  double minValue = 1000;
  double maxValue = 15000;
  double minRadius = 1000;
  var mToKm;

  @override
  void initState() {
    filterBloc = BlocProvider.of<FilterBloc>(context);

    if (filterBloc.state is! LoadedFilterState) {
      filterBloc.add(LoadFilterEvent());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FilterBloc, FilterState>(
        builder: (context, state) {
          if (state is InitialFilterState) {
            return const LoaderWidget();
          }
          if (state is LoadedFilterState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var element in state.filter)
                        for (var key in element.keys)
                          _widgetBuildFilter(
                            element: element,
                            key: key,
                            state: state,
                          ),
                      _widgetBuildButtonSearch(state),
                      _widgetBuildRecommended(state),
                    ],
                  ),
                ),
              ),
            );
          }

          return Center(
            child: Text(translations?['error'] ?? 'Error'),
          );
        },
      ),
    );
  }

  _widgetBuildFilter({element, key, state}) {
    if (key == '') {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                translations?['search_currently_not_working'] ??
                    'Search is currently not working',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          InkWell(
            onTap: key == 'year' || key == 'price' || key == 'search_radius'
                ? null
                : () async => await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchDetailScreen(
                          typeSearch: element[key],
                          typeKey: key,
                        ),
                      ),
                    ),
            child: Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 15,
                bottom: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      translations?[key].toString().toUpperCase() ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SFProDisplay-Bold',
                        fontSize: 17,
                      ),
                    ),
                  ),
                  if (key == 'year')
                    YearWidget(
                      typeKey: key,
                      element: element,
                      state: state,
                    )
                  else if (key == 'price')
                    PriceRangeWidget(
                      minPriceController: minPriceController,
                      maxPriceController: maxPriceController,
                    )
                  else if (key == 'search_radius')
                    _widgetBuildSearch()
                  else
                    Row(
                      children: [
                        //Selected Type
                        if (Provider.of<SearchFilterProvider>(context)
                            .selectedSearchFilterList
                            .containsKey(key))
                          Column(
                            children: [
                              for (var el
                                  in Provider.of<SearchFilterProvider>(context)
                                      .selectedSearchFilterList[key]!)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    border: Border.all(
                                      width: 1,
                                      color: const Color(0xffe9eef0),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  margin:
                                      const EdgeInsets.only(right: 10, top: 7),
                                  child: Row(
                                    children: [
                                      Text(
                                        el['label'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () =>
                                            Provider.of<SearchFilterProvider>(
                                          context,
                                          listen: false,
                                        ).removeElement(
                                          typeKey: key,
                                          el: el,
                                        ),
                                        child: const Icon(
                                          IconsMotors.close,
                                          size: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        const SizedBox(width: 15),
                        //Navigate Icon
                        DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                          ),
                          child: GestureDetector(
                            onTap: () async => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchDetailScreen(
                                  typeSearch: element[key],
                                  typeKey: key,
                                ),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(
                                left: 8.0,
                                right: 8,
                                top: 8,
                                bottom: 8,
                              ),
                              child: Icon(
                                IconsMotors.arrowIos,
                                color: Colors.grey,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const Divider(thickness: 1, height: 0)
        ],
      );
    }
  }

  _widgetBuildSearch() {
    return Slider(
      value: sliderKm,
      min: minValue,
      max: maxValue,
      divisions: 7,
      inactiveColor: Colors.black,
      activeColor: Colors.redAccent,
      thumbColor: mainColor,
      label: '${sliderKm / 1000}km',
      onChanged: (values) {
        setState(() {
          sliderKm = values;
          minRadius = values;
          var minRadiusForApi = values;
          mToKm = minRadiusForApi / 1000;
        });
      },
    );
  }

  _widgetBuildButtonSearch(LoadedFilterState state) {
    bool isDisabled = false;
    for (var el in state.filter) {
      for (var el1 in el.keys) {
        if (el1 == '') {
          isDisabled = true;
        }
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(isDisabled ? Colors.grey : mainColor),
        ),
        onPressed: isDisabled
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  for (var element in state.filter) {
                    element.forEach((key, value) {
                      if (Provider.of<SearchFilterProvider>(
                        context,
                        listen: false,
                      ).selectedSearchFilterList.containsKey(key)) {
                        for (var i = 0;
                            i <
                                Provider.of<SearchFilterProvider>(
                                  context,
                                  listen: false,
                                ).selectedSearchFilterList[key]!.length;
                            i++) {
                          filteredListForSearch.addAll({
                            '$key[$i]': Provider.of<SearchFilterProvider>(
                              context,
                              listen: false,
                            ).selectedSearchFilterList[key]![i]['slug']
                          });
                        }
                      }
                    });
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        // log(json.encode(filteredListForSearch));
                        // log(filteredListForSearch.toString());
                        return SearchResult(
                          filters: filteredListForSearch.isEmpty
                              ? {}
                              : filteredListForSearch,
                          min_price: minPriceController.text == ''
                              ? 0
                              : minPriceController.text,
                          max_price: maxPriceController.text == ''
                              ? 0
                              : maxPriceController.text,
                          min_year: Provider.of<SearchFilterProvider>(
                            context,
                            listen: false,
                          ).from,
                          max_year: Provider.of<SearchFilterProvider>(
                            context,
                            listen: false,
                          ).to,
                          search_radius: mToKm,
                        );
                      },
                    ),
                  ).then(
                    (value) => setState(() {
                      Provider.of<SearchFilterProvider>(context, listen: false)
                          .setValueTo = translations?['to'] ?? 'To';
                      Provider.of<SearchFilterProvider>(context, listen: false)
                          .setValueFrom = translations?['from'] ?? 'From';
                      minPriceController.clear();
                      maxPriceController.clear();
                      filteredListForSearch;
                    }),
                  );
                }
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                IconsMotors.searchLight,
                size: 15,
              ),
              const SizedBox(width: 5),
              Text(
                translations!['vehicles'],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _widgetBuildRecommended(LoadedFilterState state) {
    return ColoredBox(
      color: const Color(0xff1f2224),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Text "RECOMMENDED"
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0),
            child: Text(
              translations!['recomended'].toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          //Card
          Container(
            margin: const EdgeInsets.only(top: 40, bottom: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 120, maxHeight: 230),
              child: ListView.builder(
                itemCount: state.featuredResponse.featured.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext ctx, int index) {
                  var item = state.featuredResponse.featured[index];
                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarDetailScreen(
                          idCar: item!.ID,
                        ),
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(right: 20, left: 20),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        color: Color(0xff323536),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Image(
                                image: NetworkImage(
                                  item!.img ??
                                      'https://appmotors.stylemix.biz/wp-content/uploads/2015/12/placeholder-690x410.gif',
                                ),
                                fit: BoxFit.fitHeight,
                                width: 180,
                                height: 165,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4,
                                      right: 6,
                                      bottom: 4,
                                      left: 6,
                                    ),
                                    child: Text(
                                      '${item.price}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 7,
                                bottom: 7,
                                left: 10,
                                right: 10,
                              ),
                              child: Text(
                                item.title ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
