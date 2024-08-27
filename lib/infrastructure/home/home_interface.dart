import 'package:image_picker/image_picker.dart';

import '../apiUtil/response_wrappers.dart';

abstract class HomeInterface {
  Future<ResponseWrapper<dynamic>> registerService({
    required String sessionId,
    required XFile image,
  });
  Future<ResponseWrapper<dynamic>> applyFilter({
    required String filterName,
    required String sessionId,
  });
  Future<ResponseWrapper<dynamic>> applyAiFilter({
    required String aiFilterName,
    required String sessionId,
  });
}
