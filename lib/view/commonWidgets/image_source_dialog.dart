import 'package:filter/viewModels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../common/colors.dart';
import '../../common/images.dart';

class ImageSourceDialog extends StatelessWidget {
  const ImageSourceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyColors.whiteColor,
      title: Text(
        'Choose Image',
        style: TextStyle(color: MyColors.appDark),
      ),
      content: Container(
        height: 100,
        color: MyColors.whiteColor,
        // padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                context.read<HomeViewModel>().pickImage(ImageSource.gallery);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      AppImages.gallery,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Gallery',
                    style: TextStyle(color: MyColors.blackColor),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                context.read<HomeViewModel>().pickImage(ImageSource.camera);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      AppImages.camera,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Camera',
                    style: TextStyle(color: MyColors.blackColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
