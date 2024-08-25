import 'package:filter/viewModels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/colors.dart';

// ignore: must_be_immutable
class WidgetDialog extends StatelessWidget {
  WidgetDialog({
    super.key,
    required this.content,
    this.confirmFunction,
    required this.title,
    this.cancelFunction,
    this.confirmText,
  });
  final String title;
  final Widget content;
  Function? confirmFunction;
  Function? cancelFunction;
  String? confirmText;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !context.watch<HomeViewModel>().isApplyingFilter,
      child: AlertDialog(
        backgroundColor: MyColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        // title: Wrap(
        //   spacing: 10,
        //   children: [
        //     Icon(
        //       Icons.info,
        //       color: MyColors.appDark,
        //     ),
        //     Text(
        //       context.watch<HomeViewModel>().isApplyingFilter
        //           ? "Google AD"
        //           : title,
        //       style: TextStyle(color: MyColors.appDark),
        //     ),
        //     const Divider(),
        //   ],
        // ),
        content: context.watch<HomeViewModel>().isApplyingFilter
            ? Container(
                height: 350,
                width: 350,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://cdn.prod.website-files.com/66015f733bbb59672132aee2/66016301256cc8095aeca1fb_64703481041bb767ea996fe6_Startbucks%2520logo%2520on%2520product%2520gif%2520example.gif"),
                    fit: BoxFit.contain,
                  ),
                ),
              )
            : content,
        contentPadding: const EdgeInsets.all(10),
        actions: context.watch<HomeViewModel>().isApplyingFilter
            ? []
            : [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        confirmText != null ? Colors.grey : MyColors.appDark,
                  ),
                  onPressed: () {
                    if (cancelFunction != null) {
                      cancelFunction!();
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Back',
                  ),
                ),
                confirmText != null
                    ? ElevatedButton(
                        onPressed: () {
                          confirmFunction!();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              context.watch<HomeViewModel>().isApplyingFilter
                                  ? Colors.grey
                                  : MyColors.appDark,
                        ),
                        child: Text(
                          confirmText!,
                        ),
                      )
                    : Container(),
              ],
      ),
    );
  }
}
