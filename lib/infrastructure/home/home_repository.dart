import 'package:dio/dio.dart';
import 'package:filter/infrastructure/home/api/register_service_api.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/prefs_keys.dart';
import '../apiUtil/response_wrappers.dart';
import 'home_interface.dart';

class HomeRepository implements HomeInterface {
  HomeRepository({required this.registerServiceApi});
  final RegisterServiceApi registerServiceApi;

  @override
  Future<ResponseWrapper<dynamic>> registerService({
    required String sessionId,
    required XFile image,
  }) async {
    Response response = await registerServiceApi.registerService(
      sessionId: sessionId,
      image: image,
    );
    var res = ResponseWrapper<dynamic>();
    res.status = response.data[PrefsKeys.status];
    res.data = response.data[PrefsKeys.data];
    res.message = response.data[PrefsKeys.message];
    return res;
  }
}
