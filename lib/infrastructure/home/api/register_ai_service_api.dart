import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../apiUtil/urls.dart';

class RegisterAiServiceApi {
  RegisterAiServiceApi({required this.dio});
  final Dio dio;
  Future<dynamic> registerAiService({
    required XFile image,
  }) async {
    final bytes = await image.readAsBytes();
    final headers = {
      'content-type': 'image/jpeg',
    };
    print(
        "${Urls.registerTargetApi}${Urls.sessionId} İşlem başarılı. Bu şekilde bir dosya gönderim olayı başlatılacak");
    Response response = await dio.post(
    Urls.registerTargetApi + Urls.sessionId,
      data: bytes,
      options: Options(
        headers: headers,
      ),
    );
    return response;
  }
}
