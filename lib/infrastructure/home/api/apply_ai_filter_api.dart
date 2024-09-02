import 'package:dio/dio.dart';

import '../../apiUtil/urls.dart';

class ApplyAiFilterApi {
  ApplyAiFilterApi({required this.dio});

  final Dio dio;

  Future<dynamic> applyAiFilter({
    required String aiFilterName,
  }) async {
    Response response = await dio.get(
      "${Urls.applyFilter}${aiFilterName.replaceAll("-", "/")}?id=${Urls.sessionId}",
      // "${Urls.applyFilter}${Urls.aiFilter}${aiFilterName.replaceAll("-", "/")}?id=${Urls.sessionId}",

      options: Options(responseType: ResponseType.bytes),
    );
    return response;
  }
}
