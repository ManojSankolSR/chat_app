import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _captureByCamera() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
    widget.onPickImage(_pickedImageFile!);
  }

  void _uplaodFromDevice() async {
    final uplaoadedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (uplaoadedimage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(uplaoadedimage.path);
    });
    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _captureByCamera,
              icon: const Icon(Icons.camera),
              label: Text(
                'Camera',
                style: TextStyle(),
              ),
            ),
            TextButton.icon(
              onPressed: _uplaodFromDevice,
              icon: const Icon(Icons.upload_outlined),
              label: Text(
                'Upload Image',
                style: TextStyle(),
              ),
            ),
          ],
        )
      ],
    );
  }
}
