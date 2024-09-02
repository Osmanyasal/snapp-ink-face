import 'package:dio/dio.dart';
import 'package:filter/infrastructure/home/api/apply_filter_api.dart';
import 'package:filter/infrastructure/home/api/register_service_api.dart';
import 'package:image_picker/image_picker.dart';


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
    res.status = response.statusCode;
    res.data = response.data;
    res.message = response.statusMessage;
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
    res.status = response.statusCode;
    res.data = response.data;
    res.message = response.statusMessage;
    return res;
  }

  @override
  Future<ResponseWrapper<dynamic>> applyAiFilter({
    required String aiFilterName,

  }) async {
    Response response = await applyAiFilterApi.applyAiFilter(
      aiFilterName: aiFilterName,

    );
    var res = ResponseWrapper<dynamic>();
    res.status = response.statusCode;
    res.data = response.data;
    res.message = response.statusMessage;
    return res;
  }
}
