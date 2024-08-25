import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/colors.dart';
import '../../../../common/images.dart';
import '../../../../viewModels/home_view_model.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    double kWidth = MediaQuery.of(context).size.width;
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        return Container(
          width: kWidth,
          color: homeViewModel.selectedFile.path.isEmpty
              ? MyColors.whiteColor
              : MyColors.blackColor,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: homeViewModel.selectedFile.path.isNotEmpty
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              if (homeViewModel.selectedFile.path.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    homeViewModel.changeFilterType(1);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage(AppImages.filters),
                          fit: BoxFit.cover,
                        ),
                        // border: homeViewModel.typeOfFilter == 1
                        //     ? Border.all(width: 1, color: MyColors.whiteColor)
                        //     : Border.all(width: 0),
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  context.read<HomeViewModel>().requestPermissions(context);
                },
                child: Container(
                  height: 80,
                  width: 80,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.appLogo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              if (homeViewModel.selectedFile.path.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    homeViewModel.changeFilterType(2);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage(AppImages.aiFilters),
                          fit: BoxFit.cover,
                        ),
                        // border: homeViewModel.typeOfFilter == 2
                        //     ? Border.all(width: 1, color: MyColors.whiteColor)
                        //     : Border.all(width: 0),
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
