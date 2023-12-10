import 'package:flutter/material.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/presentation/bloc/car_detail/car_detail_bloc.dart';
import 'package:motors_app/presentation/screens/screens.dart';

class AuthorWidget extends StatelessWidget {
  const AuthorWidget({Key? key, required this.state}) : super(key: key);

  final LoadedCarDetailState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      // color: const Color,
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => DealerProfile(
                      dealerId: state.loadedDetailCar.author!.userId.toString(),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: CircleAvatar(
                        child: state.loadedDetailCar.author!.image != null &&
                                state.loadedDetailCar.author!.image
                                        .toString() !=
                                    ''
                            ? Image.network(state.loadedDetailCar.author!.image)
                            : const Image(
                                image: AssetImage('assets/images/avatar.png'),
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        state.loadedDetailCar.author!.name != null &&
                                state.loadedDetailCar.author!.name != ''
                            ? Text(
                                state.loadedDetailCar.author!.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : const SizedBox(),
                        Text(
                          state.loadedDetailCar.author!.userRole ==
                                  'Private Seller'
                              ? translations!['private_seller'] ??
                                  'Private Seller'
                              : state.loadedDetailCar.author!.userRole,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: grey88,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    translations?['added'] ?? 'ADDED',
                    style: TextStyle(
                      color: black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    state.loadedDetailCar.author!.regDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Visibility(
            visible: state.loadedDetailCar.info[1]?.infoTwo != null &&
                    state.loadedDetailCar.info[1]?.infoTwo != ''
                ? true
                : false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'KMS Driven: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        state.loadedDetailCar.info[1]?.infoTwo ?? '',
                        style: const TextStyle(
                          color: Color(0xff616161),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.4), // Set color to grey
                    thickness: 1.0, // Set thickness
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: state.loadedDetailCar.title.toString().split(' ').length >
                        1 &&
                    state.loadedDetailCar.title.toString().split(' ')[0] != ''
                ? true
                : false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Make: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        state.loadedDetailCar.title.toString().split(' ')[0] ??
                            '',
                        style: const TextStyle(
                          color: Color(0xff616161),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.4), // Set color to grey
                    thickness: 1.0, // Set thickness
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Model: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      state.loadedDetailCar.title.toString().split(' ').length >
                              1
                          ? state.loadedDetailCar.title
                                  .toString()
                                  .split(' ')[1] ??
                              ''
                          : '',
                      style: const TextStyle(
                        color: Color(0xff616161),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey.withOpacity(0.4), // Set color to grey
                  thickness: 1.0, // Set thickness
                ),
              ],
            ),
          ),
          Visibility(
            visible: state.loadedDetailCar.info[2]?.infoTwo != null &&
                    state.loadedDetailCar.info[2]?.infoTwo != ''
                ? true
                : false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fuel: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        state.loadedDetailCar.info[2]?.infoTwo ?? '',
                        style: const TextStyle(
                          color: Color(0xff616161),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.4), // Set color to grey
                    thickness: 1.0, // Set thickness
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: state.loadedDetailCar.info[4]?.infoTwo != null &&
                    state.loadedDetailCar.info[4]?.infoTwo != ''
                ? true
                : false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Registration city: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        state.loadedDetailCar.info[4]?.infoTwo ?? '',
                        style: const TextStyle(
                          color: Color(0xff616161),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.4), // Set color to grey
                    thickness: 1.0, // Set thickness
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: state.loadedDetailCar.info[3]?.infoTwo != null &&
                    state.loadedDetailCar.info[3]?.infoTwo != ''
                ? true
                : false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transmission: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        state.loadedDetailCar.info[3]?.infoTwo ?? '',
                        style: const TextStyle(
                          color: Color(0xff616161),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.4), // Set color to grey
                    thickness: 1.0, // Set thickness
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: state.loadedDetailCar.subTitle
                            .toString()
                            .split(' ')
                            .length >
                        1 &&
                    state.loadedDetailCar.subTitle.toString().split(' ')[1] !=
                        ''
                ? true
                : false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Condition: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        state.loadedDetailCar.subTitle
                                    .toString()
                                    .split(' ')
                                    .length >
                                1
                            ? state.loadedDetailCar.subTitle
                                    .toString()
                                    .split(' ')[1] ??
                                ''
                            : '',
                        style: const TextStyle(
                          color: Color(0xff616161),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey
                        .withOpacity(0.4)
                        .withOpacity(0.4), // Set color to grey
                    thickness: 1.0, // Set thickness
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: state.loadedDetailCar.subTitle
                            .toString()
                            .split(' ')
                            .length >
                        1 &&
                    state.loadedDetailCar.subTitle.toString().split(' ')[0] !=
                        ''
                ? true
                : false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Year: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        state.loadedDetailCar.subTitle
                                    .toString()
                                    .split(' ')
                                    .length >
                                1
                            ? state.loadedDetailCar.subTitle
                                    .toString()
                                    .split(' ')[0] ??
                                ''
                            : '',
                        style: const TextStyle(
                          color: Color(0xff616161),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey
                        .withOpacity(0.4)
                        .withOpacity(0.4), // Set color to grey
                    thickness: 1.0, // Set thickness
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 35),
        ],
      ),
    );
  }
}
