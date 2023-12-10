import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/shared_components/components.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/presentation/bloc/filter_result/filter_result_bloc.dart';
import 'package:motors_app/presentation/screens/home/widgets/search_widget.dart';
import 'package:motors_app/presentation/screens/screens.dart';
import 'package:motors_app/presentation/screens/search/search_result/widgets/custom_bottom_sheet.dart';
import 'package:motors_app/presentation/screens/search/search_result/widgets/custom_slider.dart';
import 'package:motors_app/presentation/screens/search/search_result/widgets/toggle_filter-buttons.dart';
import 'package:motors_app/presentation/screens/search/search_result/widgets/toggle_radio_box.dart';
import 'package:motors_app/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:searchable_listview/searchable_listview.dart';

class SearchResult extends StatefulWidget {
  SearchResult({
    Key? key,
    this.filters = const {},
    this.min_price,
    this.max_price,
    this.min_year,
    this.max_year,
    this.search_radius,
    this.query,
    this.isFromHome = false,
  }) : super(key: key);

  static const routeName = 'searchResultScreen';

  final Map<String, dynamic> filters;
  final dynamic min_price;
  final dynamic max_price;
  final dynamic min_year;
  final dynamic max_year;
  final dynamic search_radius;
  final String? query;
  bool? isFromHome;

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  late FilterResultBloc filterResultBloc;

  @override
  void initState() {
    filterResultBloc = BlocProvider.of<FilterResultBloc>(context);

    if (widget.query != null) {
      filterResultBloc
          .add(searchEvent(widget.query!, isFromHome: widget.isFromHome));
      widget.isFromHome = false;
    } else {
      filterResultBloc.add(
        AddToFilterEvent(
          limit: -1,
          condition: widget.filters,
          min_price: widget.min_price,
          max_price: widget.max_price,
          min_year: widget.min_year,
          max_year: widget.max_year,
          search_radius: widget.search_radius,
        ),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: AppBarIcon(
          iconData: IconsMotors.arrow_back,
          onTap: () {
            Navigator.of(context).pop;
          },
        ),
        title: Text(
          translations!['search_result'] ?? 'Search Result',
          style: TextStyle(
            color: grey88,
            fontSize: 14,
          ),
        ),
      ),
      body: Column(
        children: [
          SearchWidget(),
          BlocBuilder<FilterResultBloc, FilterState>(
            builder: (context, state) {
              return SizedBox(
                height: 50,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    const SizedBox(width: 20),
                    IconButton(
                      // decrease icon padding and width between icon and text

                      constraints: BoxConstraints(
                        minWidth: 0,
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        _showSortBottomSheet();
                      },
                      icon: Icon(
                        Icons.sort,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    Center(
                      child: Text(
                        translations!['sort'] ?? 'Sort',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          // decrease text padding and width between icon and text
                          wordSpacing: -1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ToggleTextBtns(
                      selectedColor: Colors.blue[500]!,
                      multipleSelectionsAllowed: false,
                      canUnToggle: true,
                      texts: [
                        Text(
                          translations!['price_filter'] ?? 'Price',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          translations!['location_filter'] ?? 'Location',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Make',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          translations!['model_year'] ?? 'Model Year',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      selected: (index) {
                        if (index == 0) {
                          showCustomBottomSheet(
                            context,
                            type: 'price',
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: SliderContainer(
                                sliderValue:
                                    state is LoadedFilteredListingsState
                                        ? state.maxPrice ?? 10000000
                                        : 10000000,
                                onChanged: (v1, v2) {
                                  Provider.of<SearchFilterProvider>(
                                    context,
                                    listen: false,
                                  ).setValueFrom = v1.toInt().toString();
                                  Provider.of<SearchFilterProvider>(
                                    context,
                                    listen: false,
                                  ).setValueTo = v2.toInt().toString();
                                },
                              ),
                            ),
                            submitButton: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width / 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: mainColor,
                              onPressed: () {
                                filterResultBloc.add(
                                  AddToFilterEvent(
                                    limit: -1,
                                    condition: widget.filters,
                                    min_price:
                                        Provider.of<SearchFilterProvider>(
                                      context,
                                      listen: false,
                                    ).from,
                                    max_price:
                                        Provider.of<SearchFilterProvider>(
                                      context,
                                      listen: false,
                                    ).to,
                                    min_year: widget.min_year,
                                    max_year: widget.max_year,
                                    search_radius: widget.search_radius,
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              child: Text('Apply Filter'),
                            ),
                          );
                          return true;
                        }
                        if (index == 1) {
                          showCustomBottomSheet(
                            context,
                            type: 'location',
                            child: SearchableList(
                              onItemSelected: (item) {
                                filterResultBloc.add(
                                  AddToFilterEvent(
                                    limit: -1,
                                    condition: widget.filters,
                                    min_price: widget.min_price,
                                    max_price: widget.max_price,
                                    min_year: widget.min_year,
                                    max_year: widget.max_year,
                                    search_radius: widget.search_radius,
                                    location: item,
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              defaultSuffixIconColor: Colors.transparent,
                              inputDecoration: InputDecoration(
                                suffix: null,
                                suffixIcon: null,
                                contentPadding: EdgeInsets.zero,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                hintText: 'Type to refine search',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  // height: 1,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey,

                                    // width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    // width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    // width: 1,
                                  ),
                                ),
                              ),
                              spaceBetweenSearchAndList: 30,
                              initialList: state is LoadedFilteredListingsState
                                  ? state.locations != null
                                      ? (state.locations!)
                                      : []
                                  : preferences.getStringList('locations') ??
                                      [],
                              filter: (item) {
                                return state is LoadedFilteredListingsState
                                    ? state.locations!
                                        .where(
                                          (element) => element
                                              .toString()
                                              .toLowerCase()
                                              .contains(item.toLowerCase()),
                                        )
                                        .toList()
                                    : [];
                              },
                              builder: (displayedList, itemIndex, item) {
                                //print('Item: i');
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    state is LoadedFilteredListingsState
                                        ? state.locations != null
                                            ? (state.locations![item])
                                            : []
                                        : preferences.getStringList(
                                              'locations',
                                            )![item] ??
                                            [],
                                    //item!.toString() ?? '',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                          return true;
                        }
                        if (index == 2) {
                          showCustomBottomSheet(
                            context,
                            type: 'model',
                            child: SearchableList(
                              onItemSelected: (item) {
                                filterResultBloc.add(
                                  AddToFilterEvent(
                                    limit: -1,
                                    condition: widget.filters,
                                    min_price: widget.min_price,
                                    max_price: widget.max_price,
                                    min_year: widget.min_year,
                                    max_year: widget.max_year,
                                    search_radius: widget.search_radius,
                                    model: item,
                                  ),
                                );
                                // print(preferences
                                //     .getStringList('models')
                                //     .toString());

                                Navigator.pop(context);
                              },
                              defaultSuffixIconColor: Colors.transparent,
                              inputDecoration: InputDecoration(
                                suffix: null,
                                suffixIcon: null,
                                contentPadding: EdgeInsets.zero,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                hintText: 'Type to refine search',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  // height: 1,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey,

                                    // width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    // width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    // width: 1,
                                  ),
                                ),
                              ),
                              spaceBetweenSearchAndList: 30,
                              //initialList: //initialModelsList,
                              initialList: state is LoadedFilteredListingsState
                                  ? state.models != null
                                      ? (state.models!)
                                      //preferences.getStringList('models')
                                      : []
                                  : preferences.getStringList('models') ?? [],
                              filter: (item) {
                                //initialModelsList!.add(item);
                                return state is LoadedFilteredListingsState
                                    ? state.models!
                                        .where(
                                          (element) => element
                                              .toString()
                                              .toLowerCase()
                                              .contains(item.toLowerCase()),
                                        )
                                        .toList()
                                    : [];
                              },
                              builder: (displayedList, itemIndex, item) {
                                print('Reached here in models $item');
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    preferences
                                        .getStringList('models')![item]
                                        .toCapitalized(),
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                          return true;
                        }
                        if (index == 3) {
                          showCustomBottomSheet(
                            context,
                            type: 'model_year',
                            child: SliderContainer(
                              type: 'model_year',
                              sliderValue: // current year
                                  DateTime.now().year.toDouble(),
                              onChanged: (v1, v2) {
                                Provider.of<SearchFilterProvider>(
                                  context,
                                  listen: false,
                                ).setValueFrom = v1.toInt().toString();
                                Provider.of<SearchFilterProvider>(
                                  context,
                                  listen: false,
                                ).setValueTo = v2.toInt().toString();
                              },
                            ),
                            submitButton: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width / 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: mainColor,
                              onPressed: () {
                                filterResultBloc.add(
                                  AddToFilterEvent(
                                    limit: -1,
                                    condition: widget.filters,
                                    min_price: widget.min_price,
                                    max_price: widget.max_price,
                                    min_year: Provider.of<SearchFilterProvider>(
                                      context,
                                      listen: false,
                                    ).from,
                                    max_year: Provider.of<SearchFilterProvider>(
                                      context,
                                      listen: false,
                                    ).to,
                                    search_radius: widget.search_radius,
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              child: Text('Apply Filter'),
                            ),
                          );
                          return true;
                        }

                        return false;
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<FilterResultBloc, FilterState>(
              builder: (context, state) {
                if (state is InitialFilterListingState) {
                  return LoaderWidget();
                }

                if (state is LoadedFilteredListingsState) {
                  var listings = state.loadedFilteredListings[0]['listings'];

                  return Expanded(
                    child: SafeArea(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: listings.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(thickness: 1.5),
                        itemBuilder: (BuildContext context, int index) {
                          var item = listings[index];

                          if (inventoryType == 'inventory_view_grid') {
                            return InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CarDetailScreen(
                                    idCar: item['ID'],
                                  ),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                  left: 20,
                                  right: 20,
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: const Color(0xffF3F3F3),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            child: CachedNetworkImage(
                                              height: 170,
                                              width: double.infinity,
                                              imageUrl: '${item['imgUrl']}',
                                              fit: BoxFit.fitWidth,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              errorWidget: (
                                                context,
                                                url,
                                                error,
                                              ) =>
                                                  const Icon(Icons.error),
                                            ),
                                          ),
                                          //Img count
                                          Visibility(
                                            visible: item['grid']
                                                        ['infoTitle'] ==
                                                    'imgcount'
                                                ? false
                                                : true,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.15),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(
                                                      5,
                                                    ),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                margin: const EdgeInsets.only(
                                                  right: 8,
                                                  top: 8,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                      IconsMotors.addPhoto,
                                                      size: 15,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      '${item['gallery'].length}',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.15),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(
                                                      5,
                                                    ),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                margin: const EdgeInsets.only(
                                                  right: 8,
                                                  top: 8,
                                                ),
                                                child: Text(
                                                  overflow: TextOverflow.clip,
                                                  item['grid']['infoDesc']
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(
                                                            state.currentCity !=
                                                                    ''
                                                                ? state
                                                                    .currentCity!
                                                                    .toLowerCase()
                                                                : 'not_found',
                                                          )
                                                      ? 'Near you'
                                                      : '',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            visible: item['grid']
                                                        ['infoTitle'] ==
                                                    'imgcount'
                                                ? false
                                                : true,
                                          ),
                                        ],
                                      ),
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          // bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //Price
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                              ),
                                              child: ColoredBox(
                                                color: mainColor,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10,
                                                    top: 15,
                                                    bottom: 15,
                                                  ),
                                                  child: Text(
                                                    item['price'],
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(20),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 5.0,
                                                        left: 10,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          //Title
                                                          Text(
                                                            item['grid']['subTitle']
                                                                        .toString()
                                                                        .length >
                                                                    15
                                                                ? "${item['grid']['subTitle'].toString().substring(0, 15)}.."
                                                                : item['grid'][
                                                                        'subTitle'] ??
                                                                    'No info',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                          ),
                                                          //Subtitle
                                                          Text(
                                                            item['grid']['title']
                                                                        .toString()
                                                                        .length >
                                                                    15
                                                                ? '${item['grid']['title'].toString().substring(0, 15)}...'
                                                                : item['grid'][
                                                                        'title'] ??
                                                                    '',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        if (item['grid']
                                                                ['infoTitle'] ==
                                                            'imgcount')
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  top: 5.0,
                                                                ),
                                                                child: Icon(
                                                                  IconsMotors
                                                                      .addPhoto,
                                                                  size: 20,
                                                                  color:
                                                                      mainColor,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              //Text
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  top: 5.0,
                                                                  right: 5,
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      item['gallery']
                                                                          .length
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color:
                                                                            grey1,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        else
                                                          ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                5,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    top: 5.0,
                                                                  ),
                                                                  child: Icon(
                                                                    dictionaryIcons[
                                                                        listings],
                                                                    size: 20,
                                                                    color:
                                                                        mainColor,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                //Text
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .only(
                                                                    bottomRight:
                                                                        Radius
                                                                            .circular(
                                                                      10,
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      top: 5.0,
                                                                      right: 30,
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          item['grid']['infoTitle'] ??
                                                                              '',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                grey1,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.clip,
                                                                        ),
                                                                        Text(
                                                                          item['grid']['infoDesc'] ??
                                                                              '',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.clip,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
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
                          } else {
                            return InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CarDetailScreen(
                                    idCar: item['ID'],
                                  ),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 20,
                                  left: 20,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Img,Price
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(2),
                                          ),
                                          child: Image(
                                            image: NetworkImage(
                                              item['imgUrl'],
                                            ),
                                            height: 125,
                                            width: 150,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                            ),
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
                                                  '${item['price']}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //Title car
                                          Text(
                                            item['list']['title'],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          //Mileage,Body
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              //Mileage
                                              if (item['list']['infoOneDesc'] ==
                                                      null ||
                                                  item['list']['infoOneDesc'] ==
                                                      '')
                                                const SizedBox()
                                              else
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 1.0,
                                                        ),
                                                        child: Icon(
                                                          dictionaryIcons[item[
                                                                  'list']
                                                              ['infoOneIcon']],
                                                          color: mainColor,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              item['list'][
                                                                  'infoOneTitle'],
                                                              style: TextStyle(
                                                                color: grey1,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                            Text(
                                                              item['list']['infoOneDesc']
                                                                          .toString()
                                                                          .length >
                                                                      10
                                                                  ? '${item['list']['infoOneDesc'].toString().substring(0, 5)}...'
                                                                  : item['list']
                                                                      [
                                                                      'infoOneDesc'],
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              const SizedBox(width: 20),
                                              //Body
                                              if (item['list']['infoTwoDesc'] ==
                                                      null ||
                                                  item['list']['infoTwoDesc'] ==
                                                      '')
                                                const SizedBox()
                                              else
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 1.0,
                                                        ),
                                                        child: Icon(
                                                          dictionaryIcons[item[
                                                                  'list']
                                                              ['infoTwoIcon']],
                                                          color: mainColor,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              item['list'][
                                                                  'infoTwoTitle'],
                                                              style: TextStyle(
                                                                color: grey1,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                            Text(
                                                              item['list']['infoTwoDesc']
                                                                          .toString()
                                                                          .length >
                                                                      5
                                                                  ? '${item['list']['infoTwoDesc'].toString().substring(0, 5)}...'
                                                                  : item['list']
                                                                      [
                                                                      'infoTwoDesc'],
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          //Fuel,Transmission
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              //Fuel
                                              if (item['list']
                                                          ['infoThreeDesc'] ==
                                                      null ||
                                                  item['list']
                                                          ['infoThreeDesc'] ==
                                                      '')
                                                const SizedBox()
                                              else
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 1.0,
                                                        ),
                                                        child: Icon(
                                                          dictionaryIcons[item[
                                                                  'list'][
                                                              'infoThreeIcon']],
                                                          color: mainColor,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              item['list'][
                                                                  'infoThreeTitle'],
                                                              style: TextStyle(
                                                                color: grey1,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                            Text(
                                                              item['list']['infoThreeDesc']
                                                                          .toString()
                                                                          .length >
                                                                      10
                                                                  ? '${item['list']['infoThreeDesc'].toString().substring(0, 5)}...'
                                                                  : item['list']
                                                                      [
                                                                      'infoThreeDesc'],
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              const SizedBox(width: 20),
                                              //Transmission
                                              if (item['list']
                                                          ['infoFourDesc'] ==
                                                      null ||
                                                  item['list']
                                                          ['infoFourDesc'] ==
                                                      '')
                                                const SizedBox()
                                              else
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 1.0,
                                                        ),
                                                        child: Icon(
                                                          dictionaryIcons[item[
                                                                  'list']
                                                              ['infoFourIcon']],
                                                          color: mainColor,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item['list']['infoFourTitle']
                                                                        .toString()
                                                                        .length >
                                                                    8
                                                                ? '${item['list']['infoFourTitle'].toString().substring(0, 5)}...'
                                                                : item['list'][
                                                                        'infoFourTitle'] ??
                                                                    '',
                                                            style: TextStyle(
                                                              color: grey1,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                          Text(
                                                            item['list']['infoFourDesc']
                                                                        .toString()
                                                                        .length >
                                                                    8
                                                                ? '${item['list']['infoFourDesc'].toString().substring(0, 5)}...'
                                                                : item['list'][
                                                                    'infoFourDesc'],
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                }

                if (state is EmptyFilteredListingState) {
                  return Center(
                    child: Text(
                      translations?['filter_is_empty'] ?? 'Filter is empty',
                    ),
                  );
                }

                return Center(
                  child: Text(translations?['error'] ?? 'Error'),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SizedBox(height: 0),
    );
  }

  _showSortBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      useSafeArea: true,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 500),
      ),
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: ListTile(
                  leading: Text(translations!['sort_by'] ?? 'Sort by'),
                  trailing: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(IconsMotors.close),
                  ),
                ),
              ),
              BlocBuilder<FilterResultBloc, FilterState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: () {
                      if (state is LoadedFilteredListingsState) {
                        // log(state.groupValue.toString());
                      }
                      filterResultBloc.add(
                        AddToFilterEvent(
                          limit: -1,
                          condition: widget.filters,
                          min_price: widget.min_price,
                          max_price: widget.max_price,
                          min_year: widget.min_year,
                          max_year: widget.max_year,
                          search_radius: widget.search_radius,
                          sort: 0,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Text(
                        translations!['price_asc'] ?? 'Price (low to high)',
                      ),
                      trailing: ToggleRadioBox(
                        selected: state is LoadedFilteredListingsState
                            ? state.groupValue == 0
                                ? true
                                : false
                            : false,
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<FilterResultBloc, FilterState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: () {
                      if (state is LoadedFilteredListingsState) {
                        // log(state.groupValue.toString());
                      }
                      filterResultBloc.add(
                        AddToFilterEvent(
                          limit: -1,
                          condition: widget.filters,
                          min_price: widget.min_price,
                          max_price: widget.max_price,
                          min_year: widget.min_year,
                          max_year: widget.max_year,
                          search_radius: widget.search_radius,
                          sort: 1,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Text(
                        translations!['price_dsc'] ?? 'Price (high to low)',
                      ),
                      trailing: ToggleRadioBox(
                        selected: state is LoadedFilteredListingsState
                            ? state.groupValue == 1
                                ? true
                                : false
                            : false,
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<FilterResultBloc, FilterState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: () {
                      if (state is LoadedFilteredListingsState) {
                        // log(state.groupValue.toString());
                      }
                      filterResultBloc.add(
                        AddToFilterEvent(
                          limit: -1,
                          condition: widget.filters,
                          min_price: widget.min_price,
                          max_price: widget.max_price,
                          min_year: widget.min_year,
                          max_year: widget.max_year,
                          search_radius: widget.search_radius,
                          sort: 2,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Text(
                        translations!['year_asc'] ??
                            'Manfactured year (low to high)',
                      ),
                      trailing: ToggleRadioBox(
                        selected: state is LoadedFilteredListingsState
                            ? state.groupValue == 2
                                ? true
                                : false
                            : false,
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<FilterResultBloc, FilterState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: () {
                      if (state is LoadedFilteredListingsState) {
                        // log(state.groupValue.toString());
                      }
                      filterResultBloc.add(
                        AddToFilterEvent(
                          limit: -1,
                          condition: widget.filters,
                          min_price: widget.min_price,
                          max_price: widget.max_price,
                          min_year: widget.min_year,
                          max_year: widget.max_year,
                          search_radius: widget.search_radius,
                          sort: 3,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Text(
                        translations!['year_dsc'] ??
                            'Manfactured year (high to low)',
                      ),
                      trailing: ToggleRadioBox(
                        selected: state is LoadedFilteredListingsState
                            ? state.groupValue == 3
                                ? true
                                : false
                            : false,
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<FilterResultBloc, FilterState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: () {
                      if (state is LoadedFilteredListingsState) {
                        // log(state.groupValue.toString());
                      }
                      filterResultBloc.add(
                        AddToFilterEvent(
                          limit: -1,
                          condition: widget.filters,
                          min_price: widget.min_price,
                          max_price: widget.max_price,
                          min_year: widget.min_year,
                          max_year: widget.max_year,
                          search_radius: widget.search_radius,
                          sort: 4,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Text(
                        translations!['milage_asc'] ?? 'Milage (low to high)',
                      ),
                      trailing: ToggleRadioBox(
                        selected: state is LoadedFilteredListingsState
                            ? state.groupValue == 4
                                ? true
                                : false
                            : false,
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<FilterResultBloc, FilterState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: () {
                      if (state is LoadedFilteredListingsState) {
                        // log(state.groupValue.toString());
                      }
                      filterResultBloc.add(
                        AddToFilterEvent(
                          limit: -1,
                          condition: widget.filters,
                          min_price: widget.min_price,
                          max_price: widget.max_price,
                          min_year: widget.min_year,
                          max_year: widget.max_year,
                          search_radius: widget.search_radius,
                          sort: 5,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Text(
                        translations!['milage_dsc'] ?? 'Milage (high to low)',
                      ),
                      trailing: ToggleRadioBox(
                        selected: state is LoadedFilteredListingsState
                            ? state.groupValue == 5
                                ? true
                                : false
                            : false,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
