import 'package:image_picker/image_picker.dart';

import 'apiUtil/response_wrappers.dart';
import 'home/home_repository.dart';

// This class is the medium between repositories
// and business logic which is provider in this case
// business model request data from the catalog
// and catalog redirect that request and retrieve
// that data and emitted back to business model

class CatalogFacadeService {
  const CatalogFacadeService({
    required this.homeRepository,
  });

  final HomeRepository homeRepository;

  Future<ResponseWrapper<dynamic>> registerService({
    required String sessionId,
    required XFile image,
  }) async {
    return await homeRepository.registerService(
      sessionId: sessionId,
      image: image,
    );
  }
}
