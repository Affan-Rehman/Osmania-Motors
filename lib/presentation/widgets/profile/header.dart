import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/data/models/user/user.dart';
import 'package:motors_app/presentation/screens/edit_profile/edit_profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key, required this.author}) : super(key: key);

  final Author author;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Avatar
        CircleAvatar(
          radius: 35,
          child: ClipOval(
            child: author.image == null || author.image == ''
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
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        //Name
        Text(
          '${author.name} ${author.lastName}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        //Edit Button
        SizedBox(
          height: 35,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent.withOpacity(0),
              side: BorderSide(
                width: 1,
                color: secondaryColor,
              ),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfile(author: author),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit,
                  size: 18,
                  color: secondaryColor,
                ),
                const SizedBox(width: 5),
                Text(
                  translations!['edit_profile'] ?? 'Edit Profile',
                  style: TextStyle(
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 35),
        //Call button and sms button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: author.phone == null || author.phone == '' ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
            children: [
              //Phone
              Visibility(
                visible: author.phone == null || author.phone == '' ? false : true,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shadowColor: MaterialStateProperty.all(Colors.black),
                    backgroundColor: MaterialStateProperty.all(secondaryColor),
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
                      mainAxisSize: MainAxisSize.min,
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
              const SizedBox(width: 10),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        IconsMotors.message,
                        size: 15,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        translations?['send_message'] ?? 'Send Message',
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
      ],
    );
  }
}
