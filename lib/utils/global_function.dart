import 'dart:math';

import 'package:dio/dio.dart';
import 'package:filter/utils/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../common/colors.dart';
import '../common/prefs_keys.dart';

showToast({required String message, required BuildContext context}) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: MyColors.whiteColor,
    textColor: MyColors.blackColor,
    fontSize: 16.0,
  );
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _random = Random();
String getRandomString(int length) => String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(_random.nextInt(_chars.length)),
      ),
    );

void handleDioError(DioException e) {
  e.type == DioExceptionType.connectionError
      ? showToast(
          message:
              "Something went wrong!\nPlease check your internet connection",
          context: NavigationService.navigatorKey.currentContext!,
        )
      : e.response == null
          ? showToast(
              message:
                  "Connection error\n Please check your internet connection",
              context: NavigationService.navigatorKey.currentContext!,
            )
          : e.response!.statusCode == 500
              ? showToast(
                  message: 'Server Error',
                  context: NavigationService.navigatorKey.currentContext!)
              : e.response != null &&
                      e.response?.data != null &&
                      e.response?.data != '' &&
                      e.response!.statusCode != 400 &&
                      e.response!.statusCode != 401
                  ? showToast(
                      message:
                          e.response?.data[PrefsKeys.data] ?? e.response?.data,
                      context: NavigationService.navigatorKey.currentContext!)
                  : showToast(
                      message:
                          "Connection error\n Please check your internet connection",
                      context: NavigationService.navigatorKey.currentContext!,
                    );
}
