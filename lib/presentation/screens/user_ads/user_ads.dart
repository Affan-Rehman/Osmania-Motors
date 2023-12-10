import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/shared_components/components.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/user/user.dart';
import 'package:motors_app/presentation/bloc/add_car/add_car_bloc.dart';
import 'package:motors_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:motors_app/presentation/screens/screens.dart';
import 'package:motors_app/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class UserAds extends StatefulWidget {
  const UserAds({super.key, this.updateState});
  static const String routeName = '/user-ads';
  final dynamic updateState;

  @override
  State<UserAds> createState() => _UserAdsState();
}

bool isLoadingDelete = false;

class _UserAdsState extends State<UserAds> {
  var userId = preferences.getString('userId');
  var _favColor = Colors.red;

  bool isLoadingUpdate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener(
            bloc: BlocProvider.of<ProfileBloc>(context),
            listener: (context, state) {
              if (state is SuccessDeleteCarState) {
                Fluttertoast.showToast(
                  msg: translations?['car_deleted'] ?? 'Car deleted',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                ).then((value) {
                  setState(() {
                    isLoadingDelete = false;
                  });
                  BlocProvider.of<ProfileBloc>(context)
                      .add(LoadProfileEvent(userId));
                });
              }

              if (state is ErrorDeleteCarState) {
                Fluttertoast.showToast(
                  msg: state.message,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                ).then((value) {
                  setState(() {
                    isLoadingDelete = false;
                  });

                  BlocProvider.of<ProfileBloc>(context)
                      .add(LoadProfileEvent(userId));
                });
              }

              if (state is SuccessGetEditCarDataState) {
                state.response.forEach((key, value) {
                  if (key == 'car_location') {
                    carData['stm_location_text'] = value;
                  }

                  if (key == 'car_lat') {
                    carData['stm_lat'] = value;
                  }

                  if (key == 'car_lng') {
                    carData['stm_lng'] = value;
                  }

                  if (key == 'features') {
                    if (value.isNotEmpty) {
                      value.forEach((key, value) {
                        carFeatures[key] = value;
                      });

                      Provider.of<AddCarFunctions>(context, listen: false)
                          .addCarMap['features'] = carFeatures;
                    }
                  }

                  if (key == 'gallery') {
                    for (var el in value) {
                      Provider.of<ImagePickerProvider>(context, listen: false)
                          .addImageNetworkToList(el['src']);

                      Provider.of<AddCarFunctions>(context, listen: false)
                              .addCarMap['add_media'] =
                          Provider.of<ImagePickerProvider>(
                        context,
                        listen: false,
                      ).imageList;
                    }
                  }
                });

                setState(() {
                  isLoadingUpdate = false;
                });
              }

              if (state is SuccessRemovedCarState) {
                BlocProvider.of<ProfileBloc>(context)
                    .add(LoadProfileEvent(userId));
              }
            },
          ),
        ],
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is InitialProfileState) {
              return const LoaderWidget();
            }

            if (state is LoadedProfileState) {
              // Author author = state.userInfo.author;

              return RefreshIndicator(
                onRefresh: () async => BlocProvider.of<ProfileBloc>(context)
                    .add(LoadProfileEvent(userId)),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Header
                          // HeaderWidget(author: author),
                          Text(
                            translations!['my_ads'] ?? 'My Ads',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          //MY INVENTORY
                          const Divider(
                            endIndent: 25,
                            indent: 25,
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                          _widgetInventory(state),
                          const SizedBox(height: 40),
                          //MY FAVOURITES
                          // const SizedBox(height: 40),
                          //MY FAVOURITES
                          Text(
                            translations!['my_favourites'] ?? 'My Favourites',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const Divider(
                            endIndent: 25,
                            indent: 25,
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                          _widgetFavourites(state.userInfo.favourites, state),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return const LoaderWidget();
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(LoadProfileEvent(userId));
    // TODO: implement initState
    super.initState();
  }

  _widgetInventory(LoadedProfileState state) {
    if (state.isListingsEmpty == true) {
      return Center(
        child: Text(
          translations!['ads_empty'] ?? 'Ads Empty',
          style: TextStyle(
            color: grey1,
            fontSize: 15,
          ),
        ),
      );
    } else {
      return Column(
        children: [
          for (var el in state.userInfo.listings)
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarDetailScreen(
                    idCar: el.ID,
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Img,Price
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: Image(
                                image: NetworkImage(el.imgUrl),
                                height: 125,
                                width: 150,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
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
                                      '${el.price}',
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
                                el.list.title ?? '',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //Mileage
                                  if (el.list.infoOneDesc == null ||
                                      el.list.infoOneDesc == '')
                                    const Expanded(child: SizedBox())
                                  else
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1.0),
                                            child: Icon(
                                              dictionaryIcons[
                                                  el.list.infoOneIcon],
                                              color: mainColor,
                                              size: 18,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                el.list.infoOneTitle.toString(),
                                                style: TextStyle(
                                                  color: grey1,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  el.list.infoOneDesc
                                                              .toString()
                                                              .length >
                                                          6
                                                      ? '${el.list.infoOneDesc.toString().substring(0, 6)}...'
                                                      : el.list.infoOneDesc,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(width: 5),
                                  //Body
                                  if (el.list.infoTwoDesc == null ||
                                      el.list.infoTwoDesc == '')
                                    const Expanded(child: SizedBox())
                                  else
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1.0),
                                            child: Icon(
                                              dictionaryIcons[
                                                  el.list.infoTwoIcon],
                                              color: mainColor,
                                              size: 18,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                el.list.infoTwoTitle,
                                                style: TextStyle(
                                                  color: grey1,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                el.list.infoTwoDesc
                                                            .toString()
                                                            .length >
                                                        6
                                                    ? '${el.list.infoTwoDesc.toString().substring(0, 6)}...'
                                                    : el.list.infoTwoDesc,
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
                              const SizedBox(height: 20),
                              //Fuel,Transmission
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //Fuel
                                  if (el.list.infoThreeDesc == null ||
                                      el.list.infoThreeDesc == '')
                                    const SizedBox()
                                  else
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1.0),
                                            child: Icon(
                                              dictionaryIcons[
                                                  el.list.infoThreeIcon],
                                              color: mainColor,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    el.list.infoThreeTitle,
                                                    style: TextStyle(
                                                      color: grey1,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    el.list.infoThreeDesc
                                                                .toString()
                                                                .length >
                                                            5
                                                        ? '${el.list.infoThreeDesc.toString().substring(0, 5)}...'
                                                        : el.list.infoThreeDesc,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(width: 5),
                                  //Transmission
                                  if (el.list.infoFourDesc == null ||
                                      el.list.infoFourDesc == '')
                                    const SizedBox()
                                  else
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1.0),
                                            child: Icon(
                                              dictionaryIcons[
                                                  el.list.infoFourIcon],
                                              color: mainColor,
                                              size: 18,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  el.list.infoFourTitle,
                                                  style: TextStyle(
                                                    color: grey1,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                el.list.infoFourDesc
                                                            .toString()
                                                            .length >
                                                        6
                                                    ? '${el.list.infoFourDesc.toString().substring(0, 6)}...'
                                                    : el.list.infoFourDesc,
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
                    Container(
                      color: Colors.transparent,
                      margin: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Update Button (Edit)
                          // Expanded(
                          //   flex: 1,
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       setState(() {
                          //         isLoadingUpdate = true;
                          //       });
                          //       update = true;
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) => AddCarScreen(
                          //             isEdit: true,
                          //             postId: el.ID,
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //         border: Border.all(color: Colors.white),
                          //         borderRadius: BorderRadius.circular(3),
                          //         color: Colors.black,
                          //       ),
                          //       padding: const EdgeInsets.symmetric(
                          //         horizontal: 5,
                          //         vertical: 5,
                          //       ),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           const Icon(
                          //             Icons.edit,
                          //             color: Colors.white,
                          //           ),
                          //           const SizedBox(width: 5),
                          //           Text(
                          //             translations?['update'] ?? 'Update',
                          //             style: TextStyle(
                          //               color: Colors.white,
                          //               fontWeight: FontWeight.w500,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          const SizedBox(width: 10),
                          // Delete Button
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLoadingDelete = true;
                                });

                                var data = {
                                  'user_id': userId,
                                  'user_token': preferences.getString('token'),
                                  'post_id': el.ID,
                                };

                                BlocProvider.of<ProfileBloc>(
                                  context,
                                ).add(
                                  DeleteCarEvent(
                                    data: data,
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                child: isLoadingDelete
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            translations?['delete'] ?? 'Delete',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
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
        ],
      );
    }
  }

  _widgetFavourites(List<Favourites>? favourites, LoadedProfileState state) {
    List<int> filteredFav = [];

    if (favourites != null && favourites.isNotEmpty) {
      for (var el in favourites) {
        filteredFav.add(el.ID);
      }

      for (var el in filteredFav) {
        for (var element in favourites) {
          if (el == element.ID) {
            _favColor = Colors.red;
          }
        }
      }
    }

    if (state.isFavouritesEmpty == true) {
      return Center(
        child: Text(
          translations!['favourites_empty'] ?? 'Favourites is empty',
          style: TextStyle(
            color: grey1,
            fontSize: 15,
          ),
        ),
      );
    } else {
      return Column(
        children: [
          for (var el in favourites!)
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarDetailScreen(
                    idCar: el.ID,
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Img,Price
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: Image(
                                image: NetworkImage(el.imgUrl),
                                height: 140,
                                width: 165,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
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
                                      '${el.price}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                onTap: () {
                                  for (var element in filteredFav) {
                                    if (element == el.ID) {
                                      setState(() {
                                        _favColor = Colors.grey;
                                      });
                                    }
                                  }
                                  filteredFav.remove(el.ID);

                                  BlocProvider.of<ProfileBloc>(context).add(
                                    RemoveFavouriteCarEvent(
                                      userId: userId,
                                      userToken: preferences.getString('token'),
                                      carId: el.ID,
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.favorite_rounded,
                                    color: _favColor,
                                    size: 20,
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
                                el.list.title ?? '',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //Mileage
                                  if (el.list.infoOneDesc == null ||
                                      el.list.infoOneDesc == '')
                                    const SizedBox()
                                  else
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1.0),
                                            child: Icon(
                                              dictionaryIcons[
                                                  el.list.infoOneIcon],
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
                                                el.list.infoOneTitle.toString(),
                                                style: TextStyle(
                                                  color: grey1,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                el.list.infoOneDesc
                                                            .toString()
                                                            .length >
                                                        8
                                                    ? '${el.list.infoOneDesc.toString().substring(0, 8)}...'
                                                    : el.list.infoOneDesc,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  Visibility(
                                    visible: el.list.infoOneDesc == null ||
                                            el.list.infoOneDesc == ''
                                        ? false
                                        : true,
                                    child: const SizedBox(width: 5),
                                  ),
                                  //Body
                                  if (el.list.infoTwoDesc == null ||
                                      el.list.infoTwoDesc == '')
                                    const Expanded(child: SizedBox())
                                  else
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1.0),
                                            child: Icon(
                                              dictionaryIcons[
                                                  el.list.infoTwoIcon],
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
                                                el.list.infoTwoTitle,
                                                style: TextStyle(
                                                  color: grey1,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                el.list.infoTwoDesc
                                                            .toString()
                                                            .length >
                                                        8
                                                    ? '${el.list.infoTwoDesc.toString().substring(0, 8)}...'
                                                    : el.list.infoTwoDesc,
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
                              const SizedBox(height: 20),
                              //Fuel,Transmission
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //Fuel
                                  if (el.list.infoThreeDesc == null ||
                                      el.list.infoThreeDesc == '')
                                    const SizedBox()
                                  else
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1.0),
                                            child: Icon(
                                              dictionaryIcons[
                                                  el.list.infoThreeIcon],
                                              color: mainColor,
                                              size: 18,
                                            ),
                                          ),
                                          Visibility(
                                            visible: el.list.infoOneDesc ==
                                                        null ||
                                                    el.list.infoOneDesc == ''
                                                ? false
                                                : true,
                                            child: const SizedBox(width: 5),
                                          ),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                el.list.infoThreeTitle,
                                                style: TextStyle(
                                                  color: grey1,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                el.list.infoThreeDesc
                                                            .toString()
                                                            .length >
                                                        8
                                                    ? '${el.list.infoThreeDesc.toString().substring(0, 8)}...'
                                                    : el.list.infoThreeDesc,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  Visibility(
                                    visible: el.list.infoThreeDesc == null ||
                                            el.list.infoThreeDesc == ''
                                        ? false
                                        : true,
                                    child: const SizedBox(width: 5),
                                  ),
                                  //Transmission
                                  if (el.list.infoFourDesc == null ||
                                      el.list.infoFourDesc == '')
                                    const SizedBox()
                                  else
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1.0),
                                            child: Icon(
                                              dictionaryIcons[
                                                  el.list.infoFourIcon],
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
                                                el.list.infoFourTitle
                                                    .toString(),
                                                style: TextStyle(
                                                  color: grey1,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                el.list.infoFourDesc
                                                            .toString()
                                                            .length >
                                                        8
                                                    ? '${el.list.infoFourDesc.toString().substring(0, 8)}...'
                                                    : el.list.infoFourDesc,
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
                    Container(
                      color: Colors.transparent,
                      margin: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Update Button (Edit)
                          // Expanded(
                          //   flex: 1,
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       setState(() {
                          //         isLoadingUpdate = true;
                          //       });
                          //       update = true;
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) => AddCarScreen(
                          //             postId: el.ID,
                          //             isEdit: true,
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //         border: Border.all(color: Colors.white),
                          //         borderRadius: BorderRadius.circular(3),
                          //         color: Colors.black,
                          //       ),
                          //       padding: const EdgeInsets.symmetric(
                          //         horizontal: 5,
                          //         vertical: 5,
                          //       ),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           const Icon(
                          //             Icons.edit,
                          //             color: Colors.white,
                          //           ),
                          //           const SizedBox(width: 5),
                          //           Text(
                          //             translations?['update'] ?? 'Update',
                          //             style: TextStyle(
                          //               color: Colors.white,
                          //               fontWeight: FontWeight.w500,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          const SizedBox(width: 10),
                          // Delete Button
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLoadingDelete = true;
                                });

                                var data = {
                                  'user_id': userId,
                                  'user_token': preferences.getString('token'),
                                  'post_id': el.ID,
                                };

                                BlocProvider.of<ProfileBloc>(
                                  context,
                                ).add(
                                  DeleteCarEvent(
                                    data: data,
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                child: isLoadingDelete
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            translations?['delete'] ?? 'Delete',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
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
        ],
      );
    }
  }
}
