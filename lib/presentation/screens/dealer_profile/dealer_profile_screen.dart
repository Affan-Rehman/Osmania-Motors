import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/presentation/bloc/dealer_profile/dealer_profile_bloc.dart';
import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart';
import 'package:motors_app/presentation/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class DealerProfile extends StatefulWidget {
  const DealerProfile({Key? key, this.dealerId}) : super(key: key);

  static const routeName = 'dealerProfileScreen';
  final dynamic dealerId;

  @override
  State<DealerProfile> createState() => _DealerProfileState();
}

class _DealerProfileState extends State<DealerProfile> {
  late DealerProfileBloc dealerProfileBloc;

  @override
  void initState() {
    dealerProfileBloc = BlocProvider.of<DealerProfileBloc>(context);

    dealerProfileBloc.add(LoadDealerProfileEvent(dealerId: widget.dealerId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarIcon(
          iconData: IconsMotors.arrow_back,
          onTap: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          translations!['dealer_profile'] ?? 'Dealer Profile',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
      body: BlocBuilder<DealerProfileBloc, DealerProfileState>(
        builder: (context, state) {
          if (state is InitialDealerProfileState) {
            return const LoaderWidget();
          }

          if (state is LoadedDealerProfileState) {
            var author = state.dealerResponse.author;
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    //Avatar
                    Center(
                      child: CircleAvatar(
                        radius: 35,
                        child: ClipOval(
                          child: author!.image == null || author.image == ''
                              ? const Image(
                                  image: AssetImage('assets/images/avatar.png'),
                                )
                              : ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  child: CachedNetworkImage(
                                    width: double.infinity,
                                    imageUrl: '${author.image}',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    //Dealer name
                    Text(
                      author.name,
                      style: const TextStyle(
                        fontFamily: 'SFProDisplay-Semibold',
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 25),
                    //Call button and sms button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: author.phone == null || author.phone == '' ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
                        children: [
                          //Phone
                          Visibility(
                            visible: author.phone == null || author.phone == '' ? false : true,
                            child: SizedBox(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(5),
                                  shadowColor: MaterialStateProperty.all(Colors.black),
                                  backgroundColor: MaterialStateProperty.all(secondaryColor),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (author.phone == null || author.phone == '') {
                                    log('No phone');
                                  } else {
                                    final Uri launchUri = Uri(scheme: 'tel', path: author.phone);

                                    if (await canLaunchUrl(launchUri)) {
                                      await launchUrl(launchUri);
                                    } else {
                                      throw 'Could not launch $launchUri';
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0),
                                  child: Row(
                                    children: [
                                      const Icon(IconsMotors.phone, size: 15),
                                      const SizedBox(width: 5),
                                      Text(
                                        author.phone,
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //Message
                          ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(5),
                              shadowColor: MaterialStateProperty.all(Colors.black),
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (author.phone != null && author.phone != '') {
                                final Uri launchUri = Uri(scheme: 'sms', path: author.phone);

                                await launchUrl(launchUri);
                              } else {
                                final Uri launchUri = Uri(scheme: 'mailto', path: author.email);

                                await launchUrl(launchUri);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0),
                              child: Row(
                                children: [
                                  const Icon(
                                    IconsMotors.message,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    translations!['send_message'],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    //Sellers Inventory
                    Text(
                      translations!['sellers_inventory'] ?? 'Sellers Inventory',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'SFProDisplay-Bold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(
                      endIndent: 40,
                      indent: 40,
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                    //Listings
                    _widgetListings(state),
                  ],
                ),
              ),
            );
          }

          return Center(child: Text(translations?['error'] ?? 'Error'));
        },
      ),
      bottomNavigationBar: const SizedBox(height: 0),
    );
  }

  _widgetListings(state) {
    return Column(
      children: [
        for (var el in state.dealerResponse.listings)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarDetailScreen(
                    idCar: el!.ID,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Img,Price
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(2)),
                        child: Image(
                          image: NetworkImage(el!.imgUrl),
                          height: 140,
                          width: 165,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: mainColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4, right: 6, bottom: 4, left: 6),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Mileage
                            if (el.list.infoOneDesc == null || el.list.infoOneDesc == '')
                              const Expanded(child: SizedBox())
                            else
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1.0),
                                      child: Icon(
                                        dictionaryIcons[el.list.infoOneIcon],
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          el.list.infoOneTitle.toString().length > 6 ? '${el.list.infoOneTitle.toString().substring(0, 6)}...' : el.list.infoOneTitle,
                                          style: TextStyle(
                                            color: grey1,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          el.list.infoOneDesc.toString().length > 5 ? '${el.list.infoOneDesc.toString().substring(0, 5)}...' : el.list.infoOneDesc,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(width: 20),
                            //Body
                            if (el.list.infoTwoDesc == null || el.list.infoTwoDesc == '')
                              const Expanded(child: SizedBox())
                            else
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1.0),
                                      child: Icon(
                                        dictionaryIcons[el.list.infoTwoIcon],
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          el.list.infoTwoTitle,
                                          style: TextStyle(
                                            color: grey1,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          el.list.infoTwoDesc.toString().length > 5 ? '${el.list.infoTwoDesc.toString().substring(0, 5)}...' : el.list.infoTwoDesc,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Fuel
                            if (el.list.infoThreeDesc == null || el.list.infoThreeDesc == '')
                              const SizedBox()
                            else
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1.0),
                                      child: Icon(
                                        dictionaryIcons[el.list.infoThreeIcon],
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          el.list.infoThreeTitle,
                                          style: TextStyle(
                                            color: grey1,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          el.list.infoThreeDesc.toString().length > 10 ? '${el.list.infoThreeDesc.toString().substring(0, 5)}...' : el.list.infoThreeDesc,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(width: 20),
                            //Transmission
                            if (el.list.infoFourDesc == null || el.list.infoFourDesc == '')
                              const SizedBox()
                            else
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1.0),
                                      child: Icon(
                                        dictionaryIcons[el.list.infoFourIcon],
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          el.list.infoFourTitle.toString().length > 8 ? '${el.list.infoFourTitle.toString().substring(0, 5)}...' : el.list.infoFourTitle ?? '',
                                          style: TextStyle(
                                            color: grey1,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          el.list.infoFourDesc.toString().length > 8 ? '${el.list.infoFourDesc.toString().substring(0, 5)}...' : el.list.infoFourDesc,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}
