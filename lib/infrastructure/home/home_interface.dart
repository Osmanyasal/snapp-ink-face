import 'package:image_picker/image_picker.dart';

import '../apiUtil/response_wrappers.dart';

abstract class HomeInterface {
  Future<ResponseWrapper<dynamic>> registerService({
    required String sessionId,
    required XFile image,
  });
}
