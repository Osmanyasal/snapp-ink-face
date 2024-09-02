import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../apiUtil/urls.dart';

class RegisterServiceApi {
  RegisterServiceApi({required this.dio});
  final Dio dio;
  Future<dynamic> registerService({
    required XFile image,
  }) async {
    final bytes = await image.readAsBytes();
    final headers = {
      'content-type': 'image/jpeg',
    };

    print(
        "${Urls.registerApi}${Urls.sessionId} İşlem başarılı. Bu şekilde bir dosya gönderim olayı başlatılacak");
    Response response = await dio.post(
     Urls.registerApi + Urls.sessionId,
      data: bytes,
      options: Options(
        headers: headers,
      ),
    );
    return response;
  }
}
