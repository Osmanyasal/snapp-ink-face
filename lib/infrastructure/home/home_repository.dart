import 'package:dio/dio.dart';
import 'package:filter/infrastructure/home/api/apply_filter_api.dart';
import 'package:filter/infrastructure/home/api/register_service_api.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/prefs_keys.dart';
import '../apiUtil/response_wrappers.dart';
import 'api/apply_ai_filter_api.dart';
import 'home_interface.dart';

class HomeRepository implements HomeInterface {
  HomeRepository({
    required this.registerServiceApi,
    required this.applyFilterApi,
    required this.applyAiFilterApi,
  });
  final RegisterServiceApi registerServiceApi;
  final ApplyFilterApi applyFilterApi;
  final ApplyAiFilterApi applyAiFilterApi;

  @override
  Future<ResponseWrapper<dynamic>> registerService({

    required XFile image,
  }) async {
    Response response = await registerServiceApi.registerService(
     
      image: image,
    );
    var res = ResponseWrapper<dynamic>();
    res.status = response.data[PrefsKeys.status];
    res.data = response.data[PrefsKeys.data];
    res.message = response.data[PrefsKeys.message];
    return res;
  }

  @override
  Future<ResponseWrapper<dynamic>> applyFilter({
    required String filterName,

  }) async {
    Response response = await applyFilterApi.applyFilter(
      filterName: filterName,
    );
    var res = ResponseWrapper<dynamic>();
    res.status = response.data[PrefsKeys.status];
    res.data = response.data[PrefsKeys.data];
    res.message = response.data[PrefsKeys.message];
    return res;
  }

  @override
  Future<ResponseWrapper<dynamic>> applyAiFilter({
    required String aiFilterName,
    required String sessionId,
  }) async {
    Response response = await applyAiFilterApi.applyAiFilter(
      aiFilterName: aiFilterName,
      sessionId: sessionId,
    );
    var res = ResponseWrapper<dynamic>();
    res.status = response.data[PrefsKeys.status];
    res.data = response.data[PrefsKeys.data];
    res.message = response.data[PrefsKeys.message];
    return res;
  }
}
