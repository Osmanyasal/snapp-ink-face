import 'package:dio/dio.dart';

import '../../apiUtil/urls.dart';

class ApplyFilterApi {
  ApplyFilterApi({required this.dio});

  final Dio dio;

  Future<dynamic> applyFilter({
    required String filterName,
  }) async {

    Response response = await dio.get(
      "${Urls.applyFilter}${filterName.replaceAll("-", "/")}?id=${Urls.sessionId}",
      options: Options(responseType: ResponseType.bytes),
    );

   

    return response;
  }
}
