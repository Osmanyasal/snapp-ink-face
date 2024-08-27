import 'package:dio/dio.dart';

import '../../apiUtil/urls.dart';

class ApplyFilterApi {
  ApplyFilterApi({required this.dio});

  final Dio dio;

  Future<dynamic> applyFilter({
    required String filterName,
    required String sessionId,
  }) async {
    Response response = await dio.get(
      '${Urls.applyFilter}$filterName?id=$sessionId',
    );
    return response;
  }
}
