import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/presentation/bloc/add_car/add_car_bloc.dart';
import 'package:provider/provider.dart';

class ImagePickerProvider extends ChangeNotifier {
  File? _image;
  final List<File> _imageList = [];

  final List<dynamic> _imageListNetwork = [];

  File? get image => _image;

  List<File>? get imageList => _imageList;

  List<dynamic>? get imageListNetwork => _imageListNetwork;

  Future<void> pickImg() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _image = File(image.path);
    } else {
      log('Error upload photo');
    }
    notifyListeners();
  }

  void openCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      _image = File(photo.path);
    } else {
      log('Error upload photo');
    }

    notifyListeners();
  }

  void deleteImg() async {
    _image = null;
    notifyListeners();
  }

  Future<void> pickImgList() async {
    final List<XFile> image = await picker.pickMultiImage();

    if (image.isNotEmpty) {
      for (var el in image) {
        _imageList.add(File(el.path));
      }
    }

    notifyListeners();
  }

  Future deleteImageList({el, context}) async {
    _imageList.removeAt(el);

    if (_imageList.isEmpty) {
      if (Provider.of<AddCarFunctions>(context, listen: false).addCarMap.containsKey('add_media')) {
        Provider.of<AddCarFunctions>(context, listen: false).addCarMap.remove('add_media');
      }
    }
    notifyListeners();
  }

  Future deleteAllImage() async {
    _imageList.clear();
    notifyListeners();
  }

  void openCameraList() async {
    await picker.pickImage(source: ImageSource.camera).then((value) {
      _imageList.add(File(value!.path));
    });
    notifyListeners();
  }

  Future addImageNetworkToList(value) async {
    var file = await urlToFile(value);

    _imageList.add(file);

    notifyListeners();
  }
}
