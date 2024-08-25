import 'package:filter/common/colors.dart';
import 'package:filter/view/screens/home/widgets/background_widget.dart';
import 'package:filter/view/screens/home/widgets/bottom_navigation_bar.dart';
import 'package:filter/view/screens/home/widgets/file_image_widget.dart';
import 'package:filter/view/screens/home/widgets/filter_slider.dart';
import 'package:filter/viewModels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<HomeViewModel>(context, listen: false).registerService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double kWidth = MediaQuery.of(context).size.width;
    double kHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: kHeight,
          width: kWidth,
          color: MyColors.blackColor,
          child: Consumer<HomeViewModel>(
            builder: (context, homeViewModel, child) {
              return homeViewModel.selectedFile.path.isNotEmpty
                  ? Stack(
                      children: [
                        FileImageWidget(
                          imagePath: homeViewModel.selectedFile.path,
                        ),
                        homeViewModel.typeOfFilter == 1
                            ? const FilterSlider()
                            : homeViewModel.typeOfFilter == 2
                                ? const FilterSlider()
                                : const SizedBox(),
                      ],
                    )
                  : const BackgroundWidget();
            },
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
