import 'dart:io';

import 'package:flutter/material.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/shared_components/image_picker.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/presentation/bloc/add_car/add_car_bloc.dart';
import 'package:motors_app/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AddMedia extends StatefulWidget {
  const AddMedia({Key? key}) : super(key: key);

  static const routeName = '/addMediaScreen';

  @override
  State<AddMedia> createState() => _AddMediaState();
}

class _AddMediaState extends State<AddMedia> {
  late ImagePickerProvider imageProvider;
  late ImagePickerProvider imageProviderMethod;

  @override
  Widget build(BuildContext context) {
    imageProvider = Provider.of<ImagePickerProvider>(context);
    imageProviderMethod = Provider.of<ImagePickerProvider>(context, listen: false);

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
            if (imageProvider.imageList!.isNotEmpty)
              Expanded(
                child: ReorderableListView.builder(
                  buildDefaultDragHandles: true,
                  itemCount: imageProvider.imageList!.length,
                  onReorder: (int oldIndex, int newIndex) {
                    if (oldIndex < newIndex) {
                      int end = newIndex - 1;
                      File startItem = imageProvider.imageList![oldIndex];
                      int i = 0;
                      int local = oldIndex;

                      do {
                        imageProvider.imageList![local] = imageProvider.imageList![++local];
                        i++;
                      } while (i < end - oldIndex);
                      imageProvider.imageList![end] = startItem;
                    } else if (oldIndex > newIndex) {
                      File startItem = imageProvider.imageList![oldIndex];
                      for (int i = oldIndex; i > newIndex; i--) {
                        imageProvider.imageList![i] = imageProvider.imageList![i - 1];
                      }
                      imageProvider.imageList![newIndex] = startItem;
                    }

                    setState(() {});
                  },
                  itemBuilder: (BuildContext context, int index) {
                    var item = imageProvider.imageList![index];
                    return GestureDetector(
                      key: Key('$item'),
                      onTap: () async {
                        if (imageProvider.imageList!.isEmpty) {
                          imageProviderMethod.pickImgList();
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: grey1,
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              child: Image.file(
                                File(item.path.toString()),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () => imageProviderMethod.deleteImageList(el: index, context: context),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 25,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              GestureDetector(
                onTap: () => imageProviderMethod.pickImgList(),
                child: Container(
                  margin: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: grey1,
                  ),
                  child: const Center(
                    child: Icon(
                      IconsMotors.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            Visibility(
              visible: imageProvider.imageList!.isNotEmpty || imageProvider.imageListNetwork!.isNotEmpty ? false : true,
              child: const Spacer(),
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
                      onPressed: () async => imageProviderMethod.pickImgList(),
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
                      onPressed: () async => imageProviderMethod.openCameraList(),
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
                onPressed: () {
                  Provider.of<AddCarFunctions>(context, listen: false).addCarParams(
                    type: 'add_media',
                    element: imageProvider.imageList,
                  );

                  Navigator.of(context).pop();
                },
                child: Text(translations!['save'] ?? 'Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
