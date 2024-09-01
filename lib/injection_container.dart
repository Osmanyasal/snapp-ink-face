import 'package:dio/dio.dart';
import 'package:filter/infrastructure/home/api/apply_ai_filter_api.dart';
import 'package:filter/infrastructure/home/api/apply_filter_api.dart';
import 'package:filter/infrastructure/home/api/register_service_api.dart';
import 'package:filter/viewModels/home_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'infrastructure/apiUtil/urls.dart';
import 'infrastructure/catalog_facade_service.dart';
import 'infrastructure/home/home_repository.dart';

final GetIt serviceLocator = GetIt.instance;

// register all components to get it to inject the dependencies where we need it
Future<void> init() async {
  //core
  await registerCoreComponents();

  //catalog
  registerCatalog();

  //viewModel
  registerViewModel();

  //repository
  registerRepository();

  //ApiCall
  registerApiCalls();
}

registerApiCalls() {
  serviceLocator.registerLazySingleton(() => RegisterServiceApi(
        dio: serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => ApplyFilterApi(
        dio: serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => ApplyAiFilterApi(
        dio: serviceLocator(),
      ));
}

registerViewModel() {
  serviceLocator.registerLazySingleton(() => HomeViewModel(
        catalogFacadeService: serviceLocator(),
      ));
}

registerRepository() {
  serviceLocator.registerLazySingleton(() => HomeRepository(
        registerServiceApi: serviceLocator(),
        applyFilterApi: serviceLocator(),
        applyAiFilterApi: serviceLocator(),
      ));
}

registerCatalog() {
  serviceLocator.registerLazySingleton(() => CatalogFacadeService(
        homeRepository: serviceLocator(),
      ));
}

registerCoreComponents() async {
  serviceLocator.registerLazySingleton(() => getNetworkObj());
}

Dio getNetworkObj() {
  BaseOptions options = BaseOptions(
    baseUrl: Urls.kBaseUrl,
    connectTimeout: const Duration(milliseconds: 30000),
    receiveTimeout: const Duration(milliseconds: 30000),
  );
  Dio dio = Dio(options);

  //intercept every api request and add needed headers to it
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['Accept'] = '*/*';
        options.headers['Access-Control-Allow-Origin'] = '*';
        options.headers['apikey'] = Urls.apiKey; // API anahtarını burada ekleyin 
        handler.next(options);
      },
    ),
  );

  //dio logger to see every request and response
  //on the debug console, remove on release!!!
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 120,
  ));
  return dio;
}
