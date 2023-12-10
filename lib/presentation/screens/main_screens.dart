import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/shared_components/image_picker.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/app_settings/app_settings.dart';
import 'package:motors_app/data/models/models.dart';
import 'package:motors_app/firebase_api.dart';
import 'package:motors_app/presentation/bloc/add_car/add_car_bloc.dart';
import 'package:motors_app/presentation/screens/add_car/chooseMake.dart';
import 'package:motors_app/presentation/screens/new_request/new_request_screen.dart';
import 'package:motors_app/presentation/screens/screens.dart';
import 'package:motors_app/presentation/screens/user_ads/user_ads.dart';
import 'package:motors_app/presentation/screens/user_messages/user_messages.dart';
import 'package:motors_app/presentation/widgets/adaptive_dialog.dart';
import 'package:motors_app/presentation/widgets/main_screen/bottom_nav_bar.dart';
import 'package:motors_app/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
    this.selectedIndex,
    this.isEdit,
    this.postId,
    this.editData,
  }) : super(key: key);

  static const routeName = 'mainScreen';

  final dynamic selectedIndex;
  final dynamic isEdit;
  final dynamic postId;
  final dynamic editData;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AppSettings? appSettings;
  int? _selectedIndex;
  final _selectedItemColor = mainColor;
  final _unselectedItemColor = Colors.grey;
  var token = '';
  var userId = '';

  List<dynamic> allTypes = [];
  Map<String, dynamic> keys = {};

  onremove(List a, int b) {
    setState(() {
      a.removeAt(b);
    });
  }

  Future<void> initNotif() async {
    await FirebaseApi().initNotifications();
  }

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex ?? 0;
    token = preferences.getString('token') ?? '';
    userId = preferences.getString('userId') ?? '';
    initNotif();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('Token is: $token');
    log('UserId is: $userId');
    return Scaffold(
      key: navigatorKey,
      appBar: _selectedIndex == 0 // default appbar
          ? PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: AppBar(
                scrolledUnderElevation: 0,
                elevation: 0,
                backgroundColor: Colors.white,
                title: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Hero(
                    tag: 'logo',
                    child: logo?.isNotEmpty ?? '' != '' || logo != null
                        ? Image(
                            image: NetworkImage(logo!),
                            errorBuilder: (
                              BuildContext context,
                              Object object,
                              StackTrace? stackTrace,
                            ) {
                              return const Image(
                                image: AssetImage('assets/images/Osmania.jpg'),
                                width: 190,
                                height: 190,
                              );
                            },
                            width: 190,
                            height: 130,
                          )
                        : const Image(
                            image: AssetImage('assets/images/Osmania.jpg'),
                            width: 190,
                            height: 130,
                          ),
                  ),
                ),
              ),
            )
          : token != '' && _selectedIndex == 3 // If user is sign in
              ? AppBar(
                  scrolledUnderElevation: 0,
                  title: Text(
                    translations!['user_ads'] ?? 'User Ads',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                )
              : _selectedIndex == 2
                  ? AppBar(
                      title: Text(
                        translations!['add'] ?? 'Add',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    )
                  : _selectedIndex == 1 && token != ''
                      ? AppBar(
                          leading: AppBarIcon(
                            iconData: IconsMotors.arrow_back,
                            onTap: () {
                              carFeatures.clear();
                              carData.clear();
                              Provider.of<AddCarFunctions>(
                                context,
                                listen: false,
                              ).addCarMap.clear();
                              Provider.of<ImagePickerProvider>(
                                context,
                                listen: false,
                              ).deleteAllImage();

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
                          title: Column(
                            children: [
                              Text(
                                translations?['messages'] ?? 'Messages',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              // Text(
                              //   translations?['step_1'] ?? 'Step 1',
                              //   style: TextStyle(
                              //     color: grey88,
                              //     fontWeight: FontWeight.bold,
                              //     fontSize: 12,
                              //   ),
                              // ),
                            ],
                          ),
                        )
                      : PreferredSize(
                          // If user is not sign in
                          preferredSize: const Size.fromHeight(80.0),
                          child: AppBar(
                            leading: const SizedBox(),
                            elevation: 0.0,
                            title: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Hero(
                                tag: 'logo',
                                child:
                                    logo?.isNotEmpty ?? '' != '' || logo != null
                                        ? Image(
                                            image: NetworkImage(logo!),
                                            errorBuilder: (
                                              BuildContext context,
                                              Object object,
                                              StackTrace? stackTrace,
                                            ) {
                                              return const Image(
                                                image: AssetImage(
                                                  'assets/images/Osmania.jpg',
                                                ),
                                                width: 190,
                                                height: 130,
                                              );
                                            },
                                            width: 190,
                                            height: 130,
                                          )
                                        : const Image(
                                            image: AssetImage(
                                              'assets/images/Osmania.jpg',
                                            ),
                                            width: 190,
                                            height: 150,
                                          ),
                              ),
                            ),
                            actions: [
                              token != ''
                                  ? AppBarIcon(
                                      onTap: () {
                                        if (Platform.isIOS) {
                                          cupertinoAlertDialog(
                                            context: context,
                                            title:
                                                translations!['quit'] ?? 'Quit',
                                            content: translations![
                                                    'are_you_sure_to_quit'] ??
                                                'Are you sure to quit?',
                                            submitText:
                                                translations?['ok'] ?? 'Ok',
                                            cancelText:
                                                translations?['cancel'] ??
                                                    'Cancel',
                                            onPressedYes: () {
                                              carFeatures.clear();
                                              carData.clear();
                                              Provider.of<AddCarFunctions>(
                                                context,
                                                listen: false,
                                              ).addCarMap.clear();
                                              Provider.of<ImagePickerProvider>(
                                                context,
                                                listen: false,
                                              ).deleteAllImage();
                                              preferences.remove('token');
                                              preferences.remove('userId');
                                              preferences.remove('password');
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignInScreen(),
                                                ),
                                                (Route<dynamic> route) => false,
                                              );
                                            },
                                            onPressedNo: () {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        } else {
                                          materialAlertDialog(
                                            context: context,
                                            title:
                                                translations!['quit'] ?? 'Quit',
                                            content: translations![
                                                    'are_you_sure_to_quit'] ??
                                                'Are you sure to quit?',
                                            submitText:
                                                translations?['ok'] ?? 'Ok',
                                            cancelText:
                                                translations?['cancel'] ??
                                                    'Cancel',
                                            onPressedYes: () {
                                              carFeatures.clear();
                                              carData.clear();
                                              Provider.of<AddCarFunctions>(
                                                context,
                                                listen: false,
                                              ).addCarMap.clear();
                                              Provider.of<ImagePickerProvider>(
                                                context,
                                                listen: false,
                                              ).deleteAllImage();
                                              preferences.remove('token');
                                              preferences.remove('userId');
                                              preferences.remove('password');
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignInScreen(),
                                                ),
                                                (Route<dynamic> route) => false,
                                              );
                                            },
                                            onPressedNo: () {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        }
                                      },
                                      iconData: Icons.logout,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: _getBody(_selectedIndex!),
      ),
      bottomNavigationBar: (token == '' && _selectedIndex == 3) ||
              (token == '' && _selectedIndex == 1)
          ? const SizedBox()
          : appType == 'dealership'
              ? BottomNavigationBar(
                  selectedItemColor: _selectedItemColor,
                  unselectedItemColor: _unselectedItemColor,
                  selectedFontSize: 0,
                  type: BottomNavigationBarType.fixed,
                  onTap: onItemTapped,
                  items: [
                    BottomNavigationBarItem(
                      icon: _buildIcon(FontAwesome.home, 0),
                      label: '',
                      tooltip: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: _buildIcon(Icons.ad_units, 2),
                      label: '',
                      tooltip: 'Ads',
                    ),
                    BottomNavigationBarItem(
                      icon: _buildIcon(IconsMotors.person, 3),
                      label: '',
                      tooltip: 'Profile',
                    ),
                  ],
                )
              : BottomNavBarRaisedInset(
                  onItemTapped: onItemTapped,
                  currentIndex: _selectedIndex!,
                  buildIcon: _buildIcon,
                ),
    );
  }

  Color? _getItemColor(int index) {
    if (index == 2)
      return _selectedIndex == index ? _selectedItemColor : Colors.white;
    else
      return _selectedIndex == index
          ? _selectedItemColor
          : _unselectedItemColor;
  }

  Widget _buildIcon(IconData iconData, int index) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Icon(
        iconData,
        color: _getItemColor(index),
        size: index == 2 ? 40 : 30,
      ),
    );
  }

  void onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });

    if (value == 2 && token == '') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    }
    if (value == 1 && token == '') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    }
    if (value == 3 && token == '') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    }
    // if (value == 2 && token != '') {
    //   setState(() {
    //     _selectedIndex = 0;
    //   });
    // }
  }

  // make adaptive dialog if the user want to add car or add request

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return UserMessagesScreen();
      case 2:
        return token != ''
            ? AdaptiveDialog(
                onResult: handleDialogResult,
              )
            : const SignInScreen();
      case 3:
        return token != '' ? UserAds() : const SignInScreen();
      case 4:
        return token != '' ? ProfileScreen() : const SignInScreen();
      default:
        return const Center(
          child: Text(
            'Not implemented!',
            textScaleFactor: 1.0,
          ),
        );
    }
  }

  void handleDialogResult(String? result) {
    if (result == 'add_car') {
      AddCarDetailScreen.getEditData(widget.editData);
      AddCarDetailScreen.getIsEdit(widget.isEdit);
      AddCarDetailScreen.getPostID(widget.postId);
      // ChooseModel.getData();
      update = false;
      //  navigate to the add car screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddCarDetailScreensTwo(),
          //AddCarScreen(
          //   isEdit: widget.isEdit,
          //   postId: widget.postId,
          //   editData: widget.editData,
          // ),
        ),
      );

      // User selected to add a car
      // Handle the action here
    } else if (result == 'make_request') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewRequest(),
        ),
      );
      // User selected to make a request
      // Handle the action here
    } else if (result == null) {
      // Dialog was dismissed by the user
      // Handle the cancellation here
      // navigate to the
      setState(() {
        _selectedIndex = 0;
      });
      // AdaptiveDialog(
      //   onResult: handleDialogResult,
      // );
    }
  }
}
