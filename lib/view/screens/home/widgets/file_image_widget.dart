import 'dart:io';

import 'package:filter/viewModels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/colors.dart';

class FileImageWidget extends StatelessWidget {
  const FileImageWidget({super.key, required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    double kWidth = MediaQuery.of(context).size.width;
    double kHeight = MediaQuery.of(context).size.height;
    return Consumer<HomeViewModel>(builder: (context, homeViewModel, _) {
      return GestureDetector(
        onTap: () {
          if (homeViewModel.processedImage.isNotEmpty) {
            homeViewModel.changeFilterType(0);
          }
        },
        child: Container(
          height: kHeight,
          width: kWidth,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: homeViewModel.typeOfFilter == 0
                  ? homeViewModel.seeOldPicture
                      ? FileImage(
                          File(imagePath),
                        )
                      : AssetImage(homeViewModel.processedImage)
                  : homeViewModel.processedImage.isEmpty
                      ? FileImage(
                          File(imagePath),
                        )
                      : AssetImage(homeViewModel.processedImage),
              fit: BoxFit.contain,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      homeViewModel.filterName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => homeViewModel.removeImage(),
                      child: Icon(
                        Icons.cancel,
                        color: MyColors.appDarkLevel1,
                      ),
                    ),
                  ],
                ),
              ),
              if (homeViewModel.typeOfFilter == 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        homeViewModel.saveImageToStorage();
                        // showToast(
                        //   message: "Your picture is downloaded!",
                        //   context: context,
                        // );
                      },
                      child: Card(
                        elevation: 10,
                        color: MyColors.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.download_for_offline_rounded,
                          size: 40,
                          color: MyColors.appDarkLevel1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onLongPressStart: (press) {
                        homeViewModel.changePictureView(true);
                      },
                      onLongPressEnd: (press) {
                        homeViewModel.changePictureView(false);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(homeViewModel.seeOldPicture
                              ? "New Picture "
                              : "Previous picture "),
                          Card(
                            elevation: 10,
                            color: MyColors.whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              Icons.undo_sharp,
                              size: 30,
                              color: MyColors.appDarkLevel1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      );
    });
  }
}
