import 'dart:io';

import 'package:flutter/material.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/shared_components/image_picker.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:provider/provider.dart';

class ImageDetailScreen extends StatelessWidget {
  const ImageDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImagePickerProvider imageProvider = Provider.of<ImagePickerProvider>(context);
    ImagePickerProvider imageProviderMethod = Provider.of<ImagePickerProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xff252525),
      appBar: AppBar(
        backgroundColor: const Color(0xff252525),
        leading: AppBarIcon(
          iconData: IconsMotors.arrow_back,
          iconColor: Colors.white,
          borderColor: Colors.white,
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text(
          translations!['choose_image'] ?? 'Choose Image',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () async => imageProviderMethod.pickImg(),
                    child: Container(
                      margin: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: grey1,
                      ),
                      child: imageProvider.image != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  child: Image.file(
                                    File(imageProvider.image!.path.toString()),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () => imageProviderMethod.deleteImg(),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 25,
                                    ),
                                  ),
                                )
                              ],
                            )
                          : const Center(
                              child: Icon(
                                IconsMotors.add,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 15, bottom: 10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(secondaryColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      onPressed: () => imageProviderMethod.pickImg(),
                      child: Text(translations!['choose_photo'] ?? 'Choose Photo'),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 6,
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.only(right: 15, bottom: 10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(secondaryColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      onPressed: () async => imageProviderMethod.openCamera(),
                      child: Text(translations!['open_camera'] ?? 'Open Camera'),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(right: 15, left: 15, bottom: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(mainColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(translations!['save'] ?? 'Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
