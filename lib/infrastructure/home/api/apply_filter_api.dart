import 'package:dio/dio.dart';

import '../../apiUtil/urls.dart';

class ApplyFilterApi {
  ApplyFilterApi({required this.dio});

  final Dio dio;

  Future<dynamic> applyFilter({
    required String filterName,
  }) async {
    Response response = await dio.get(
      '${Urls.applyFilter}${Urls.applyFilter}${filterName.replaceAll('-', '/')}?id=${Urls.sessionId}',
    );
    return response;
  }
}
