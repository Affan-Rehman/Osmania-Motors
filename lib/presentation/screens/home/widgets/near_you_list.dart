import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/main_page/main_page.dart';
import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';

class NearYouList extends StatefulWidget {
  NearYouList({Key? key, required this.mainPage}) : super(key: key);
  final MainPage mainPage;

  @override
  State<NearYouList> createState() => _NearYouListState();
}

class _NearYouListState extends State<NearYouList> {
  List<dynamic> list = [];
  bool nearByEmpty = true;
  @override
  void initState() {
    filterLocations();
    super.initState();
  }

  void filterLocations() async {
    List<dynamic> mainPageRecent = widget.mainPage.recent;
    List<dynamic> filteredList = [];

    for (var item in mainPageRecent) {
      String locationName =
          item!.grid['infoDesc']; // Assuming 'infoDesc' contains location name

      try {
        List<Location> locationResults =
            await locationFromAddress(locationName);

        if (locationResults.isNotEmpty) {
          double itemLatitude = locationResults[0].latitude;
          double itemLongitude = locationResults[0].longitude;

          // Fetch your current location coordinates
          Position currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          double distanceInMeters = Geolocator.distanceBetween(
            currentPosition.latitude,
            currentPosition.longitude,
            itemLatitude,
            itemLongitude,
          );

          // Check if the location is within 100km radius
          if (distanceInMeters <= 100000) {
            filteredList.add(item);
            nearByEmpty = false;
          }
        }
      } catch (e) {
        log('Geocoding error for $locationName: $e');
        log(filteredList.length.toString());
      }
    }
    list = filteredList;
  }

  @override
  Widget build(BuildContext context) {
    if (!nearByEmpty)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(),
                Text(
                  'Near You',
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewAllNearby(
                          list: list,
                        ),
                      ),
                    );
                  },
                  child: Text('View All', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 285, // Set the height to a fixed value
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: list.length > 20 ? 20 : list.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                thickness: 1.5,
              ),
              itemBuilder: (BuildContext context, int index) {
                var item = widget.mainPage.recent[index];
                return Container(
                  margin: EdgeInsets.all(10),
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailScreen(
                            idCar: item.ID,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: const Offset(
                                      0,
                                      2,
                                    ),
                                  ),
                                ],
                              ),
                              child: CachedNetworkImage(
                                width: 200,
                                height: 125,
                                imageUrl: '${item!.imgUrl}',
                                fit: BoxFit.fill,
                                placeholder: (context, url) => const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Price and Date Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.price}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.grid['title'].toString().length > 17
                                    ? item.grid['title']
                                            .toString()
                                            .substring(0, 15) +
                                        '..'
                                    : item.grid['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '|',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                item.grid['subTitle']
                                    .toString()
                                    .replaceAll('used-cars', '')
                                    .replaceAll('new-cars', '')
                                    .trim(), // Replace with actual model year
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Location and Model Year Row
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                children: [
                                  Icon(Icons.location_on),
                                  Text(
                                    item.list[
                                        'infoThreeDesc'], // Replace with actual location
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    else
      return SizedBox.shrink();
    // return Column(
    //   children: [
    //     SizedBox(
    //       height: 50,
    //       child: Center(
    //         child: Text(
    //           'Near You',
    //           style: const TextStyle(
    //             fontSize: 16,
    //             fontWeight: FontWeight.bold,
    //             color: Colors.black,
    //           ),
    //         ),
    //       ),
    //     ),
    //     Divider(),
    //     SizedBox(
    //       height: 300,
    //       child: Center(
    //         child: Text(
    //           "No cars near you!",
    //           style: TextStyle(
    //             color: Colors.red,
    //             fontSize: 20,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}

class ViewAllNearby extends StatelessWidget {
  ViewAllNearby({Key? key, required this.list}) : super(key: key);

  final List<dynamic> list;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.red,
          title: Text(
            'All Cars',
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
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          itemCount: list.length,
          separatorBuilder: (BuildContext context, int index) => const Divider(
            thickness: 1.5,
          ),
          itemBuilder: (BuildContext context, int index) {
            var item = list[index];
            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarDetailScreen(
                    idCar: item.ID,
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 20, left: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Img,Price
                    Stack(
                      children: [
                        //Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: const Offset(
                                    0,
                                    2,
                                  ), // changes position of shadow
                                ),
                              ],
                            ),
                            child: CachedNetworkImage(
                              width: 150,
                              height: 125,
                              imageUrl: '${item!.imgUrl}',
                              fit: BoxFit.fitHeight,
                              placeholder: (context, url) => const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        //Price
                        Positioned(
                          top: 0,
                          right: 0,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              // bottomLeft: Radius.circular(10),
                            ),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: mainColor,
                                // borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
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
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Title car
                          Text(
                            item.list['title'],
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          //Mileage,Body
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Mileage
                              if (item.list['infoOneDesc'] == null ||
                                  item.list['infoOneDesc'] == '')
                                const SizedBox()
                              else
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 1.0,
                                        ),
                                        child: Icon(
                                          dictionaryIcons[
                                              item.list['infoOneIcon']],
                                          color: mainColor,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.list['infoOneTitle'],
                                              style: TextStyle(
                                                color: grey1,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              item.list['infoOneDesc']
                                                          .toString()
                                                          .length >
                                                      9
                                                  ? '${item.list['infoOneDesc'].toString().substring(0, 9)}...'
                                                  : item.list['infoOneDesc'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Visibility(
                                visible: item.list['infoOneDesc'] == null ||
                                        item.list['infoOneDesc'] == ''
                                    ? false
                                    : true,
                                child: const SizedBox(width: 5),
                              ),
                              //Body
                              if (item.list['infoTwoDesc'] == null ||
                                  item.list['infoTwoDesc'] == '')
                                const SizedBox()
                              else
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 1.0,
                                        ),
                                        child: Icon(
                                          dictionaryIcons[
                                              item.list['infoTwoIcon']],
                                          color: mainColor,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.list['infoTwoTitle'],
                                              style: TextStyle(
                                                color: grey1,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              item.list['infoTwoDesc']
                                                          .toString()
                                                          .length >
                                                      9
                                                  ? '${item.list['infoTwoDesc'].toString().substring(0, 9)}...'
                                                  : item.list['infoTwoDesc'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Fuel
                              if (item.list['infoThreeDesc'] == null ||
                                  item.list['infoThreeDesc'] == '')
                                const SizedBox()
                              else
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 1.0,
                                        ),
                                        child: Icon(
                                          dictionaryIcons[
                                              item.list['infoThreeIcon']],
                                          color: mainColor,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.list['infoThreeTitle'],
                                              style: TextStyle(
                                                color: grey1,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              item.list['infoThreeDesc']
                                                          .toString()
                                                          .length >
                                                      8
                                                  ? '${item.list['infoThreeDesc'].toString().substring(0, 8)}...'
                                                  : item.list['infoThreeDesc'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Visibility(
                                visible: item.list['infoThreeDesc'] == null ||
                                        item.list['infoThreeDesc'] == ''
                                    ? false
                                    : true,
                                child: const SizedBox(width: 5),
                              ),
                              //Transmission
                              if (item.list['infoFourDesc'] == null ||
                                  item.list['infoFourDesc'] == '')
                                const SizedBox()
                              else
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 1.0,
                                        ),
                                        child: Icon(
                                          dictionaryIcons[
                                              item.list['infoFourIcon']],
                                          color: mainColor,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.list['infoFourTitle']
                                                        .toString()
                                                        .length >
                                                    8
                                                ? '${item.list['infoFourTitle'].toString().substring(0, 5)}...'
                                                : item.list['infoFourTitle'] ??
                                                    '',
                                            style: TextStyle(
                                              color: grey1,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            item.list['infoFourDesc']
                                                        .toString()
                                                        .length >
                                                    4
                                                ? '${item.list['infoFourDesc'].toString().substring(0, 4)}...'
                                                : item.list['infoFourDesc'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
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
          },
        ),
      ),
    );
  }
}
