import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/shared_components/image_picker.dart';
import 'package:motors_app/core/shared_components/location_service.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/presentation/bloc/add_car/add_car_bloc.dart';
import 'package:motors_app/presentation/screens/add_car/add_car_detail/add_car_detail_screen.dart';
import 'package:motors_app/presentation/screens/add_car/add_car_detail/add_media.dart';
import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart';
import 'package:motors_app/presentation/screens/edit_profile/widgets/text_field.dart';
import 'package:motors_app/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class StepThreeScreen extends StatefulWidget {
  const StepThreeScreen({Key? key, this.editData, this.isEdit, this.postId})
      : super(key: key);

  static const routeName = '/stepThreeScreen';

  final dynamic isEdit;
  final dynamic editData;
  final dynamic postId;

  @override
  State<StepThreeScreen> createState() => _StepThreeScreenState();
}

class _StepThreeScreenState extends State<StepThreeScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController engineController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController mileAgeController = TextEditingController();
  TextEditingController fuelConsumptionsController = TextEditingController();
  TextEditingController sellerNotesController = TextEditingController();

  bool isInit = true;
  bool isHide = false;
  bool errorColor = false;
  bool priceIsEmpty = false;
  bool isLoading = false;

  @override
  void initState() {
    if (widget.editData != null && widget.editData.isNotEmpty) {
      widget.editData.forEach((key, value) {
        if (key == 'info') {
          value.forEach((key, value) {
            if (key == 'step_three') {
              value.forEach((key, value) {
                if (value == null || value == '') {
                  log('Value is empty');
                } else {
                  Provider.of<AddCarFunctions>(context, listen: false)
                      .addCarMap[key] = value;
                  if (key != 'add_media' &&
                      key != 'price' &&
                      key != 'location' &&
                      key != 'features' &&
                      key != 'seller_notes' &&
                      key != 'engine' &&
                      key != 'mileage' &&
                      key != 'fuel-consumption') {
                    carData['stm_t_s_$key'] = value.values
                        .toString()
                        .substring(1, value.values.toString().length - 1);
                  }

                  if (key == 'price') {
                    carData['stm_car_price'] = value;
                  }

                  if (key == 'engine') {
                    carData['stm_t_s_engine'] = value;
                  }

                  if (key == 'mileage') {
                    carData['stm_t_s_mileage'] = value;
                  }

                  if (key == 'fuel-consumptions') {
                    carData['stm_t_s_fuel_consumptions'] = value;
                  }

                  if (key == 'seller_notes') {
                    carData['stm_seller_notes'] = value;
                  }
                }
              });
            }
          });
        }
      });
    }

    carData.forEach((key, value) {
      if (key.contains('mileage')) {
        mileAgeController.text = value;
      }

      if (key.contains('engine')) {
        engineController.text = value;
      }

      if (key.contains('price')) {
        priceController.text = value;
      }

      if (key.contains('seller_notes')) {
        sellerNotesController.text = value;
      }

      if (key.contains('fuel_consumptions')) {
        fuelConsumptionsController.text = value;
      }
    });

    BlocProvider.of<AddCarBloc>(context)
        .add(LoadAddCarParamsEvent(context: context));
    super.initState();
  }

  List<dynamic> listCarFeatures = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<AddCarBloc>(context),
      listener: (context, state) {
        if (state is ErrorAddedCarState) {
          if (Platform.isIOS) {
            cupertinoAlertDialog(
              context: context,
              title: 'Error',
              content: state.message,
              cancelText: 'Back',
              submitText: 'Ok',
              onPressedYes: () {
                Navigator.of(context).pop();
              },
              onPressedNo: () {
                Navigator.of(context).pop();
              },
            );
          }

          if (Platform.isAndroid) {
            materialAlertDialog(
              context: context,
              title: 'Error',
              content: state.message,
              cancelText: 'Back',
              submitText: 'Ok',
              onPressedYes: () {
                Navigator.of(context).pop();
              },
              onPressedNo: () {
                Navigator.of(context).pop();
              },
            );
          }
        }

        if (state is SuccessAddedCarState) {
          if (!Provider.of<AddCarFunctions>(context, listen: false)
              .addCarMap
              .containsKey('add_media')) {
            setState(() {
              isLoading = false;
            });

            carFeatures.clear();
            carData.clear();
            Provider.of<AddCarFunctions>(context, listen: false)
                .addCarMap
                .clear();
            Provider.of<ImagePickerProvider>(context, listen: false)
                .deleteAllImage();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => CarDetailScreen(
                  idCar: int.parse(state.addedCarResponse.postId.toString()),
                  fromAddCar: true,
                ),
              ),
              (Route<dynamic> route) => false,
            );
          } else {
            Map<String, dynamic> mediaData = {};
            List<dynamic> bytesImgList = [];
            dynamic bytesImg;

            mediaData = {
              'user_id': preferences.getString('userId'),
              'user_token': preferences.getString('token'),
              'count': Provider.of<AddCarFunctions>(context, listen: false)
                  .addCarMap['add_media']
                  .length,
              'post_id': state.addedCarResponse.postId,
            };

            Provider.of<AddCarFunctions>(context, listen: false)
                .addCarMap
                .forEach((key, value) {
              if (key == 'add_media') {
                for (var element in value) {
                  if (value.length > 1) {
                    bytesImgList.add(base64Encode(element.readAsBytesSync()));
                  } else {
                    bytesImg = base64Encode(element.readAsBytesSync());
                  }
                }

                if (bytesImgList.isNotEmpty) {
                  for (var i = 0; i < bytesImgList.length; i++) {
                    mediaData['photos[]'] = bytesImgList;
                  }
                } else {
                  mediaData['photos[]'] = bytesImg!;
                }
              }
            });

            BlocProvider.of<AddCarBloc>(context)
                .add(UploadPhotoEvent(data: mediaData));
          }
        }

        if (state is SuccessEditCarState) {
          if (!Provider.of<AddCarFunctions>(context, listen: false)
              .addCarMap
              .containsKey('add_media')) {
            setState(() {
              isLoading = false;
            });

            carFeatures.clear();
            carData.clear();
            Provider.of<AddCarFunctions>(context, listen: false)
                .addCarMap
                .clear();
            Provider.of<ImagePickerProvider>(context, listen: false)
                .deleteAllImage();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => CarDetailScreen(
                  idCar: int.parse(state.addedCarResponse.postId.toString()),
                  fromAddCar: true,
                ),
              ),
              (Route<dynamic> route) => false,
            );
          } else {
            Map<String, dynamic> mediaData = {};
            List<dynamic> bytesImgList = [];
            dynamic bytesImg;

            mediaData = {
              'user_id': preferences.getString('userId'),
              'user_token': preferences.getString('token'),
              'count': Provider.of<AddCarFunctions>(context, listen: false)
                  .addCarMap['add_media']
                  .length,
              'post_id': widget.postId,
              'stm_edit': 'update',
            };

            Provider.of<AddCarFunctions>(context, listen: false)
                .addCarMap
                .forEach((key, value) {
              if (key == 'add_media') {
                for (var element in value) {
                  if (value.length > 1) {
                    bytesImgList.add(base64Encode(element.readAsBytesSync()));
                  } else {
                    bytesImg = base64Encode(element.readAsBytesSync());
                  }
                }

                if (bytesImgList.isNotEmpty) {
                  for (var i = 0; i < bytesImgList.length; i++) {
                    mediaData['photos[]'] = bytesImgList;
                  }
                } else {
                  mediaData['photos[]'] = bytesImg!;
                }
              }
            });

            BlocProvider.of<AddCarBloc>(context)
                .add(UploadPhotoEvent(data: mediaData));
          }
        }

        if (state is SuccessUploadCarPhotoState) {
          setState(() {
            isLoading = false;
          });
          carFeatures.clear();
          carData.clear();
          Provider.of<AddCarFunctions>(context, listen: false)
              .addCarMap
              .clear();
          Provider.of<ImagePickerProvider>(context, listen: false)
              .deleteAllImage();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => CarDetailScreen(
                idCar: int.parse(state.response['post']),
                fromAddCar: true,
              ),
            ),
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                translations?['build_your_ad'] ?? 'Build your Ad',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                translations?['step_3'] ?? 'Step 3',
                style: TextStyle(
                  color: grey88,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          leading: AppBarIcon(
            iconData: IconsMotors.arrow_back,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocBuilder<AddCarBloc, AddCarState>(
          builder: (context, state) {
            if (state is LoadedAddCarState) {
              Map item = state.addCarResponse?.stepThree;

              List<Placemark>? locations = state.locations;

              if (item.containsKey('location')) {
                if (isInit) {
                  if (locations!.isNotEmpty) {
                    locationController.text =
                        '${locations.first.country ?? ''} ${locations.first.administrativeArea ?? ''}';

                    carData['stm_s_s_location'] = locationController.text;
                    carData['stm_lat'] =
                        Provider.of<LocationService>(context, listen: false)
                            .position!
                            .latitude;
                    carData['stm_lng'] =
                        Provider.of<LocationService>(context, listen: false)
                            .position!
                            .longitude;
                    carData['stm_location_text'] = locationController.text;
                  }
                  isInit = false;
                }
              }

              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: SafeArea(
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, top: 20, right: 20, bottom: 20),
                      child: Column(
                        children: [
                          Column(
                            children: item.entries
                                .map(
                                  (e) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //Add Media
                                      if (e.key == 'add_media')
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              translations?['add_media']
                                                      .toString()
                                                      .toUpperCase() ??
                                                  'ADD MEDIA',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AddMedia(),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                ),
                                                child: Provider.of<
                                                                ImagePickerProvider>(
                                                            context)
                                                        .imageList!
                                                        .isEmpty
                                                    ? const Center(
                                                        child: Icon(
                                                          IconsMotors.addPhoto,
                                                          color: Colors.grey,
                                                          size: 30,
                                                        ),
                                                      )
                                                    : ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    10)),
                                                        child: Image.file(
                                                          File(Provider.of<
                                                                      ImagePickerProvider>(
                                                                  context)
                                                              .imageList![0]
                                                              .path
                                                              .toString()),
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height: 200,
                                                        ),
                                                      ),
                                              ),
                                            )
                                          ],
                                        )
                                      else if (e.key == 'engine')
                                        AddFormCard(
                                          type: translations?['engine']
                                                  .toString()
                                                  .toUpperCase() ??
                                              'Engine',
                                          controller: engineController,
                                          hintText: translations?['engine'] ??
                                              'Engine',
                                          typeForApi: 'engine',
                                        )
                                      else if (e.key == 'location')
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    translations?['location']
                                                            .toString()
                                                            .toUpperCase() ??
                                                        'LOCATION',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 30),
                                                Expanded(
                                                  flex: 2,
                                                  child: CustomTextField(
                                                    controller:
                                                        locationController,
                                                    onChanged: (val) async {
                                                      if (val.length == 0) {
                                                        log('Text is empty');
                                                        setState(() {
                                                          isHide = true;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          isHide = false;
                                                        });
                                                        Provider.of<AddCarFunctions>(
                                                                context,
                                                                listen: false)
                                                            .searchPlaces(
                                                                search: val);

                                                        List<Location>
                                                            locationDecode =
                                                            await locationFromAddress(
                                                                val);

                                                        carData['stm_t_s_location'] =
                                                            val;
                                                        carData['stm_lat'] =
                                                            locationDecode[0]
                                                                .latitude;
                                                        carData['stm_lng'] =
                                                            locationDecode[0]
                                                                .longitude;
                                                        carData['stm_location_text'] =
                                                            val;
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            for (var el
                                                in Provider.of<AddCarFunctions>(
                                                            context,
                                                            listen: false)
                                                        .placeSearchResponse
                                                        ?.predictions ??
                                                    [])
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        locationController
                                                                .text =
                                                            el['description'];
                                                        isHide = true;
                                                      });

                                                      List<Location>
                                                          locationDecode =
                                                          await locationFromAddress(
                                                              el['description']);

                                                      carData['stm_t_s_location'] =
                                                          el['description'];
                                                      carData['stm_lat'] =
                                                          locationDecode[0]
                                                              .latitude;
                                                      carData['stm_lng'] =
                                                          locationDecode[0]
                                                              .longitude;
                                                      carData['stm_location_text'] =
                                                          el['description'];
                                                    },
                                                    child: Visibility(
                                                      visible:
                                                          isHide ? false : true,
                                                      child: Text(
                                                        el['description'],
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible:
                                                        isHide ? false : true,
                                                    child: const Divider(
                                                      thickness: 0.5,
                                                    ),
                                                  ),
                                                ],
                                              )
                                          ],
                                        )
                                      else if (e.key == 'price')
                                        AddFormCard(
                                          type:
                                              '${translations?['price'].toString().toUpperCase() ?? 'PRICE*'}*'
                                              'PRICE*',
                                          controller: priceController,
                                          hintText: '$currency $currencyName',
                                          keyboardType: TextInputType.number,
                                          typeForApi: 'price',
                                          priceIsEmpty: priceIsEmpty,
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return translations?[
                                                      'fill_the_form'] ??
                                                  'Fill the form';
                                            }

                                            return null;
                                          },
                                        )
                                      else if (e.key == 'mileage')
                                        AddFormCard(
                                          type: translations?['mileage']
                                                  .toString()
                                                  .toUpperCase() ??
                                              'MILEAGE',
                                          controller: mileAgeController,
                                          hintText:
                                              '${translations?['km'] ?? 'Km'}',
                                          keyboardType: TextInputType.number,
                                          typeForApi: 'mileage',
                                        )
                                      else if (e.key == 'fuel-consumption')
                                        AddFormCard(
                                          type: translations?[
                                                  'fuel-consumption'] ??
                                              'Fuel consumptions',
                                          controller:
                                              fuelConsumptionsController,
                                          hintText: translations?[
                                                  'fuel-consumption'] ??
                                              'Fuel consumptions',
                                          typeForApi: 'fuel-consumption',
                                        )
                                      else if (e.key == 'seller_notes')
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              translations?['seller_note']
                                                      .toString()
                                                      .toUpperCase() ??
                                                  'Seller note',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            TextFormField(
                                              onChanged: (val) {
                                                Provider.of<AddCarFunctions>(
                                                        context,
                                                        listen: false)
                                                    .addCarParams(
                                                  type: 'seller_notes',
                                                  element: {
                                                    'slug':
                                                        sellerNotesController
                                                            .text
                                                  },
                                                );

                                                carData['seller_notes'] =
                                                    sellerNotesController.text;
                                              },
                                              controller: sellerNotesController,
                                              maxLines: 8,
                                              decoration: InputDecoration(
                                                fillColor:
                                                    const Color(0xffe9eef0),
                                                filled: true,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 0,
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      else if (e.key ==
                                          'stm_additional_features')
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                translations?[
                                                            'select_your_car_features']
                                                        .toString()
                                                        .toUpperCase() ??
                                                    'Select your car features',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              for (var el in e.value)
                                                GestureDetector(
                                                  onTap: () {
                                                    if (carFeatures.containsKey(
                                                        el['slug'])) {
                                                      setState(() {
                                                        carFeatures
                                                            .remove(el['slug']);
                                                      });
                                                      Provider.of<AddCarFunctions>(
                                                              context,
                                                              listen: false)
                                                          .addCarMap['features']
                                                          .remove('features');
                                                    } else {
                                                      setState(() {
                                                        carFeatures[
                                                                el['slug']] =
                                                            el['label'];
                                                      });
                                                    }

                                                    Provider.of<AddCarFunctions>(
                                                            context,
                                                            listen: false)
                                                        .addCarParams(
                                                      type: 'features',
                                                      element: carFeatures,
                                                    );
                                                  },
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: carFeatures
                                                                .containsKey(
                                                                    el['slug'])
                                                            ? 2
                                                            : 1.5,
                                                        color: carFeatures
                                                                .containsKey(
                                                                    el['slug'])
                                                            ? mainColor
                                                            : const Color(
                                                                0xffe9eef0),
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          el['label'],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Icon(
                                                          carFeatures.containsKey(
                                                                  el['slug'])
                                                              ? Icons
                                                                  .check_circle
                                                              : Icons.circle,
                                                          color: carFeatures
                                                                  .containsKey(el[
                                                                      'slug'])
                                                              ? mainColor
                                                              : const Color(
                                                                  0xffe9eef0),
                                                          size: 30,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        )
                                      else if (e.value.runtimeType != List)
                                        const SizedBox()
                                      else
                                        InkWell(
                                          onTap: () {
                                            if (e.value.runtimeType == List) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddCarDetailScreen(
                                                    addType: e.key,
                                                    data: e.value,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddCarDetailScreen(
                                                    addType: e.key,
                                                    data: const [],
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 20, bottom: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  translations![e.key]
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: errorColor &&
                                                            !Provider.of<
                                                                        AddCarFunctions>(
                                                                    context)
                                                                .addCarMap
                                                                .containsKey(
                                                                    e.key)
                                                        ? Colors.red
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    //Selected Type
                                                    if (Provider.of<
                                                                AddCarFunctions>(
                                                            context)
                                                        .addCarMap
                                                        .containsKey(e.key))
                                                      Column(
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          5)),
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: const Color(
                                                                      0xffe9eef0)),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  Provider.of<AddCarFunctions>(
                                                                          context)
                                                                      .addCarMap[
                                                                          e.key]
                                                                      .values
                                                                      .toString()
                                                                      .substring(
                                                                          1,
                                                                          Provider.of<AddCarFunctions>(context).addCarMap[e.key].values.toString().length -
                                                                              1),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Provider.of<AddCarFunctions>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .removeCarParams(
                                                                      type:
                                                                          e.key,
                                                                    );
                                                                  },
                                                                  child: const Icon(
                                                                      IconsMotors
                                                                          .close,
                                                                      size: 15),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    else
                                                      Text(
                                                        translations!['choose'],
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    const SizedBox(width: 5),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.5),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Colors.grey,
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    20)),
                                                      ),
                                                      child: const Icon(
                                                        Icons
                                                            .arrow_forward_ios_rounded,
                                                        color: Colors.grey,
                                                        size: 15,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      //Divider
                                      Visibility(
                                        visible:
                                            e.key == 'add_media' ? false : true,
                                        child: const Divider(),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        bottomNavigationBar: Container(
          height: 50,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(secondaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            onPressed: isLoading
                ? null
                : () {
                    if (!_formKey.currentState!.validate() &&
                        priceController.text.isEmpty) {
                      setState(() {
                        priceIsEmpty = true;
                      });
                    } else {
                      List<dynamic> filteredFeatures = [];
                      setState(() {
                        priceIsEmpty = false;
                        isLoading = true;
                      });

                      Provider.of<AddCarFunctions>(context, listen: false)
                          .addCarMap
                          .forEach((key, value) {
                        if (key != 'add_media' &&
                            key != 'price' &&
                            key != 'location' &&
                            key != 'features' &&
                            key != 'seller_notes' &&
                            key != 'mileage' &&
                            key != 'engine' &&
                            key != 'fuel-consumption') {
                          if (!carData.containsValue(value.values
                                  .toString()
                                  .substring(
                                      1, value.values.toString().length - 1)) &&
                              !carData.containsValue(value)) {
                            carData['stm_t_s_$key'] = value.values
                                .toString()
                                .substring(
                                    1, value.values.toString().length - 1);
                          } else {
                            log('Exist');
                          }
                        }

                        if (key == 'features') {
                          value.forEach((key, value) {
                            filteredFeatures.add(value);
                            var convertedFeaturesList = filteredFeatures
                                .toString()
                                .replaceAll(', ', ',');
                            carData['stm_additional_features[]'] =
                                convertedFeaturesList.toString().substring(
                                    1,
                                    convertedFeaturesList.toString().length -
                                        1);
                          });
                        }

                        if (key == 'price') {
                          carData['stm_car_price'] = value;
                        }

                        if (key == 'fuel-consumptions') {
                          carData['stm_t_s_fuel_consumption'] = value;
                        }

                        if (key == 'engine') {
                          carData['stm_t_s_engine'] = value;
                        }

                        if (key == 'mileage') {
                          carData['stm_t_s_mileage'] = value;
                        }

                        if (key == 'seller_notes') {
                          carData['stm_seller_notes'] =
                              sellerNotesController.text;
                          carData['listing_seller_note'] =
                              sellerNotesController.text;
                        }

                        if (widget.isEdit == true) {
                          carData['stm_current_car_id'] = widget.postId;
                          carData['stm_edit'] = 'update';
                        }

                        carData['stm_car_main_title'] =
                            '${carData['stm_f_s_make']} ${carData['stm_f_s_serie']}';
                        carData['user_id'] = preferences.getString('userId');
                        carData['user_token'] = preferences.getString('token');
                      });

                      if (widget.isEdit == true) {
                        BlocProvider.of<AddCarBloc>(context)
                            .add(UpdateCar(data: carData));
                      } else {
                        BlocProvider.of<AddCarBloc>(context)
                            .add(AddCar(data: carData));
                      }
                    }
                  },
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  )
                : Text(
                    translations?['publish'] ?? 'Publish',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
