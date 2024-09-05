import 'package:carousel_slider/carousel_slider.dart';
import 'package:filter/utils/global_function.dart';
import 'package:filter/utils/navigation_service.dart';
import 'package:filter/viewModels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../common/colors.dart';
import '../../../commonWidgets/filter_dialog.dart';

class CustomScrollPhysics extends ClampingScrollPhysics {
  static final SpringDescription customSpring =
      SpringDescription.withDampingRatio(mass: .5, stiffness: 1);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics();
  }

  @override
  SpringDescription get spring => customSpring;
}

bool goBackToNormalFilter = false;
bool goBackToNormalFilterAi = false;

class FilterSlider extends StatelessWidget {
  const FilterSlider({super.key});
  @override
  Widget build(BuildContext context) {
    double kWidth = MediaQuery.of(context).size.width;
    return Consumer<HomeViewModel>(builder: (context, homeViewModel, child) {
      return Positioned(
          bottom: -23,
          left: 0,
          right: 0,
          child: CarouselSlider(
            options: CarouselOptions(
                height: 140.0,
                enlargeCenterPage: false,
                autoPlay: false,
                enableInfiniteScroll: false,
                viewportFraction: 0.2,
                scrollPhysics: CustomScrollPhysics()),
            items: homeViewModel.typeOfFilter == 1
                ? homeViewModel.filters.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, String> item = entry.value;
                    return item["name"] == "add"
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => homeViewModel.requestPermissions(
                                    context, false),
                                child: Container(
                                  width: kWidth,
                                  height: 80,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 7),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 3,
                                      color:
                                          homeViewModel.selectedFilter == index
                                              ? MyColors.appDarkLevel1
                                              : MyColors.whiteColor,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 30,
                                    color: MyColors.whiteColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "Add Photo",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  homeViewModel.selectFilter(index);
                                  if (item["name"] != "Normal" ||
                                      goBackToNormalFilter) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return WidgetDialog(
                                          content: Container(
                                            height: 350,
                                            width: 350,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    item["filter"].toString()),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          title: item["name"].toString(),
                                          confirmFunction: () async {
                                            goBackToNormalFilter =
                                                index != 0 ? true : false;

                                            try {
                                              homeViewModel
                                                  .applyingFilter(true);
                                              // Navigator.pop sonrasında işlemlerin tamamlanması için kısa bir bekleme süresi ekleyin
                                              Map<String, String> filter =
                                                  homeViewModel.filters[index];
                                              String filterAssetPath =
                                                  filter["filter"]!;
                                              String filtername =
                                                  extractFilterName(
                                                      filterAssetPath);
                                              await homeViewModel.applyFilter(
                                                  filterName: filtername);
                                              await Future.delayed(const Duration(
                                                  seconds:
                                                      4)); // ads for aiFilter applying

                                              homeViewModel
                                                  .applyingFilter(false);
                                              Navigator.pop(NavigationService
                                                  .navigatorKey
                                                  .currentContext!);
                                              homeViewModel.changeFilterType(0);
                                          
                                              homeViewModel.catalogFacadeService
                                                  .homeRepository;
                                              showToast(
                                                message:
                                                    "Your picture is processed",
                                                context: NavigationService
                                                    .navigatorKey
                                                    .currentContext!,
                                              );
                                            } catch (e) {
                                              homeViewModel
                                                  .applyingFilter(false);
                                              showToast(
                                                message:
                                                    "An error occurred: $e",
                                                context: NavigationService
                                                    .navigatorKey
                                                    .currentContext!,
                                              );
                                            }
                                          },
                                          confirmText:
                                              "Apply ${item["name"].toString()}",
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  width: kWidth,
                                  height: 80,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 7),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 3,
                                      color:
                                          homeViewModel.selectedFilter == index
                                              ? MyColors.appDarkLevel1
                                              : MyColors.whiteColor,
                                    ),
                                    image: DecorationImage(
                                      image:
                                          AssetImage(item["filter"].toString()),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                item["name"].toString(),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                  }).toList()
                : homeViewModel.typeOfFilter == 2
                    ? homeViewModel.aiFilters.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, String> item = entry.value;
                        return item["name"] == "add"
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => homeViewModel
                                        .requestPermissions(context, true),
                                    child: Container(
                                      width: kWidth,
                                      height: 80,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 3,
                                          color: homeViewModel.selectedFilter ==
                                                  index
                                              ? MyColors.appDarkLevel1
                                              : MyColors.whiteColor,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        size: 30,
                                        color: MyColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Add Target",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      homeViewModel.selectFilter(index);
                                      if (item["name"] != "Normal" ||
                                          goBackToNormalFilterAi) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return WidgetDialog(
                                              content: Container(
                                                height: 350,
                                                width: 350,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        item["filter"]
                                                            .toString()),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              title: item["name"].toString(),
                                              confirmFunction: () async {
                                                goBackToNormalFilterAi =
                                                    index != 1 ? true : false;
                                                homeViewModel
                                                    .applyingFilter(true);

                                                Map<String, String> filter =
                                                    homeViewModel
                                                        .aiFilters[index];
                                                String filterAssetPath =
                                                    filter["filter"]!;
                                                String filtername =
                                                    extractFilterName(
                                                        filterAssetPath);

                                                await homeViewModel
                                                    .applyAiFilter(
                                                        aiFilterName:
                                                            filtername);
                                                await Future.delayed(const Duration(
                                                    seconds:
                                                        4)); // ads for aiFilter applying
                                                homeViewModel
                                                    .applyingFilter(false);
                                                Navigator.pop(NavigationService
                                                    .navigatorKey
                                                    .currentContext!);
                                                homeViewModel
                                                    .changeFilterType(0);
                                    
                                                showToast(
                                                  message:
                                                      "Your picture is processed",
                                                  context: NavigationService
                                                      .navigatorKey
                                                      .currentContext!,
                                                );
                                              },
                                              confirmText:
                                                  "Apply ${item["name"].toString()}",
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: kWidth,
                                      height: 80,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 3,
                                          color: homeViewModel.selectedFilter ==
                                                  index
                                              ? MyColors.appDarkLevel1
                                              : MyColors.whiteColor,
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              item["filter"].toString()),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    item["name"].toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                      }).toList()
                    : const [],
          ));
    });
  }
}

String extractFilterName(String assetPath) {
  print("ççç gelen path : $assetPath");
  int startIndex = assetPath.lastIndexOf('filters/') + 'filters/'.length;
  int endIndex = assetPath.lastIndexOf('.');
  String filterName = assetPath.substring(startIndex, endIndex);

  return filterName;
}
