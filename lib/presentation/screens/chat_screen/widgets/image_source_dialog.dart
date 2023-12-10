import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceDialog extends StatelessWidget {
  ImageSourceDialog({required this.onImageSourceSelected});
  final Function(ImageSource) onImageSourceSelected;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Image Source'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            GestureDetector(
              child: Text('Gallery'),
              onTap: () {
                onImageSourceSelected(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              child: Text('Camera'),
              onTap: () {
                onImageSourceSelected(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
