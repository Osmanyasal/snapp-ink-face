import 'package:dio/dio.dart';

import '../../apiUtil/urls.dart';

class ApplyAiFilterApi {
  ApplyAiFilterApi({required this.dio});

  final Dio dio;

  Future<dynamic> applyAiFilter({
    required String aiFilterName,
    required String sessionId,
  }) async {
    Response response = await dio.get(
      '${Urls.applyFilter}$aiFilterName?id=$sessionId',
    );
    return response;
  }
}
