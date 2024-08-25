import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../apiUtil/urls.dart';

class RegisterServiceApi {
  RegisterServiceApi({required this.dio});

  final Dio dio;

  Future<dynamic> registerService({
    required String sessionId,
    required XFile image,
  }) async {
    FormData formData = FormData();
    formData.files.add(
      MapEntry(
        'image',
        await MultipartFile.fromFile(
          image.path,
          filename: image.name,
          contentType: MediaType("image", "jpeg"),
        ),
      ),
    );
    Response response = await dio.post(
      Urls.registerApi + sessionId,
      data: formData,
    );
    return response;
  }
}
