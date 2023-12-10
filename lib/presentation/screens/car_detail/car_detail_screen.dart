import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/shared_components/toggle_fav.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/presentation/bloc/car_detail/car_detail_bloc.dart';
import 'package:motors_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:motors_app/presentation/screens/chat_screen/chat_screen.dart';
import 'package:motors_app/presentation/screens/home/widgets/recommended_card.dart';
import 'package:motors_app/presentation/screens/screens.dart';
import 'package:motors_app/presentation/widgets/CommentsWidget/comments_data.dart';
import 'package:motors_app/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CarDetailScreen extends StatefulWidget {
  const CarDetailScreen({
    Key? key,
    this.idCar,
    this.fromAddCar,
    this.fromDetailScreen = false,
  }) : super(key: key);

  static const routeName = 'carDetailScreen';

  final int? idCar;
  final bool? fromAddCar;
  final bool? fromDetailScreen;

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  late CarDetailBloc carDetailBloc;
  String? userId = preferences.getString('userId');
  var userToken = preferences.getString('token');

  @override
  void initState() {
    carDetailBloc = BlocProvider.of<CarDetailBloc>(context);

    try {
      int? parsedUserId;
      if (userId != null && userId!.isNotEmpty) {
        parsedUserId = int.tryParse(userId!);
      }

      carDetailBloc.add(
        CarDetailLoadEvent(
          id: widget.idCar!,
          userId: parsedUserId,
        ),
      );
    } catch (e) {
      final snackBar = SnackBar(
        content: Text(e.toString()),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      );

      // Find the ScaffoldMessenger in the widget tree and show the SnackBar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: carDetailBloc,
      listener: (BuildContext context, state) {
        if (state is LoadedCarDetailState) {
          Provider.of<ToggleFavouriteProvider>(context, listen: false).setFav =
              state.loadedDetailCar.inFavorites!;
          Provider.of<ToggleFavouriteProvider>(context, listen: false)
                  .setColor =
              state.loadedDetailCar.inFavorites ? mainColor : Colors.grey;
        }
      },
      child: Scaffold(
        floatingActionButton: BlocBuilder<CarDetailBloc, CarDetailState>(
          builder: (context, state) {
            if (state is InitialCarDetailState) {
              return const SizedBox();
            }
            if (state is LoadedCarDetailState)
              return Container(
                // margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                // color: Colors.white,
                child: Row(
                  mainAxisAlignment:
                      state.loadedDetailCar.author!.phone == null ||
                              state.loadedDetailCar.author!.phone == ''
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.spaceAround,
                  children: [
                    //Phone
                    Expanded(
                      child: Visibility(
                        visible: state.loadedDetailCar.author!.phone == null ||
                                state.loadedDetailCar.author!.phone == ''
                            ? false
                            : true,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(5),
                            shadowColor:
                                MaterialStateProperty.all(Colors.black),
                            backgroundColor: MaterialStateProperty.all(
                              secondaryColor,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (state.loadedDetailCar.author!.phone == null ||
                                state.loadedDetailCar.author!.phone == '') {
                              log('No phone');
                            } else {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: state.loadedDetailCar.author!.phone,
                              );

                              await launchUrl(launchUri);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                IconsMotors.phone,
                                size: 15,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                translations?['call'] ?? 'Call',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    //Message
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5),
                          shadowColor: MaterialStateProperty.all(Colors.black),
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (state.loadedDetailCar.author!.phone != null &&
                              state.loadedDetailCar.author!.phone != '') {
                            final Uri launchUri = Uri(
                              scheme: 'sms',
                              path: state.loadedDetailCar.author!.phone,
                            );

                            await launchUrl(launchUri);
                          } else {
                            final Uri launchUri = Uri(
                              scheme: 'mailto',
                              path: state.loadedDetailCar.author!.email,
                            );

                            await launchUrl(launchUri);
                          }
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                IconsMotors.message,
                                size: 15,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                translations?['sms'] ?? 'SMS',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // button for chat
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5),
                          shadowColor: MaterialStateProperty.all(Colors.black),
                          backgroundColor: MaterialStateProperty.all(
                            Colors.green[900],
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          // navigate to chat screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => ChatScreen(
                                carTitle:
                                    state.loadedDetailCar.title!.toString(),
                                dealerId: state.loadedDetailCar.author!.userId
                                    .toString(),
                                carID: state.loadedDetailCar.ID.toString(),
                                authorName: state.loadedDetailCar.author!.name!,
                              ),
                            ),
                          );
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                IconsMotors.message,
                                size: 15,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                translations?['chat'] ?? 'Chat',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            return const SizedBox();
          },
        ),
        appBar: AppBar(
          leading: BlocBuilder<CarDetailBloc, CarDetailState>(
            builder: (context, state) {
              return AppBarIcon(
                iconData: IconsMotors.arrow_back,
                onTap: state is InitialCarDetailState
                    ? () => Navigator.of(context).pop()
                    : () {
                        if (widget.fromAddCar == true) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(
                                selectedIndex: 0,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        } else if (widget.fromDetailScreen == true) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(
                                selectedIndex: 0,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
              );
            },
          ),
          title: BlocBuilder<CarDetailBloc, CarDetailState>(
            builder: (context, state) {
              if (state is LoadedCarDetailState) {
                return Column(
                  children: [
                    Text(
                      state.loadedDetailCar.subTitle,
                      style: TextStyle(
                        color: grey88,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      state.loadedDetailCar.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
          actions: [
            if (userId == null || userId == '')
              const SizedBox()
            else
              BlocBuilder<CarDetailBloc, CarDetailState>(
                builder: (context, state) {
                  return AppBarIcon(
                    onTap: () {
                      Provider.of<ToggleFavouriteProvider>(
                        context,
                        listen: false,
                      ).toggle();

                      if (state is LoadedCarDetailState) {
                        if (state.loadedDetailCar.inFavorites) {
                          carDetailBloc.add(
                            AddToFavorite(
                              userId: userId,
                              userToken: userToken,
                              carId: widget.idCar,
                              action: 'remove',
                            ),
                          );
                        } else {
                          carDetailBloc.add(
                            AddToFavorite(
                              userId: userId,
                              userToken: userToken,
                              carId: widget.idCar,
                              action: 'add',
                            ),
                          );
                        }

                        BlocProvider.of<ProfileBloc>(context)
                            .add(LoadProfileEvent(userId));
                      }
                    },
                    iconData: IconsMotors.favorite,
                    iconColor:
                        Provider.of<ToggleFavouriteProvider>(context).favColor,
                  );
                },
              ),
          ],
        ),
        body: BlocBuilder<CarDetailBloc, CarDetailState>(
          builder: (context, state) {
            if (state is InitialCarDetailState) {
              return const LoaderWidget();
            }

            if (state is LoadedCarDetailState) {
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [...checkLoggedIn(userId, state)],
                    ),
                  ),
                ],
              );
            }
            return Center(child: Text(translations?['error'] ?? 'Error'));
          },
        ),
        bottomNavigationBar: const SizedBox(height: 0),
      ),
    );
  }

  List<Widget> checkLoggedIn(userid, state) {
    if (userid == null || userid == '') {
      return [
        //Image Slider
        ImageSliderWidget(state: state),
        //Car Info
        CarInfoWidget(state: state),
        Divider(thickness: 1.5, color: mainColor, height: 0),
        //Features
        FeaturesWidget(state: state),
        Divider(thickness: 0.2, color: grey1, height: 0),

        //Author
        AuthorWidget(state: state),
        Divider(thickness: 1.5, color: mainColor, height: 0),

        //Comment
        CommentWidget(state: state),
        Divider(thickness: 1.5, color: mainColor, height: 0),

        LocationWidget(state: state),

        Divider(thickness: 1.5, color: mainColor, height: 0),

        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Text("Log in to see this vehicle's reveiws"),
        ),
        Divider(thickness: 1.5, color: mainColor, height: 0),

        //Recommended cars
        RecommendedCard(
          mainPage: state.loadedDetailCar.similar,
          fromDetailScreen: true,
        ),
        const SizedBox(height: 60),
      ];
    } else {
      return [
        //Image Slider
        ImageSliderWidget(state: state),
        //Car Info
        CarInfoWidget(state: state),
        Divider(thickness: 1.5, color: mainColor, height: 0),
        //Features
        FeaturesWidget(state: state),
        Divider(thickness: 0.2, color: grey1, height: 0),

        //Author
        AuthorWidget(state: state),
        Divider(thickness: 1.5, color: mainColor, height: 0),

        //Comment
        CommentWidget(state: state),
        Divider(thickness: 1.5, color: mainColor, height: 0),

        LocationWidget(state: state),
        Divider(thickness: 1.5, color: mainColor, height: 0),

        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 8, 8),
          child: CommentWidget2(
            postId: widget.idCar.toString(),
            userID: userId,
          ),
        ),
        Divider(thickness: 1.5, color: mainColor, height: 0),

        //Recommended cars
        RecommendedCard(
          mainPage: state.loadedDetailCar.similar,
          fromDetailScreen: true,
        ),
        const SizedBox(height: 60),
      ];
    }
  }
}
