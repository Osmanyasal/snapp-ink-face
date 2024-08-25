import 'package:flutter/material.dart';

import '../../../../common/colors.dart';
import '../../../../common/images.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            AppImages.backgroundImage,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Column(
              children: [
                Text(
                  "Hello!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: MyColors.appDark,
                  ),
                ),
                Text(
                  "Let's create magic together! ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                    color: MyColors.whiteColor,
                  ),
                ),
              ],
            ),
            Text(
              "Please select the picture by clicking the button below",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: MyColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
