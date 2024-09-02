import 'dart:io';

import 'package:dio/dio.dart';
import 'package:filter/infrastructure/apiUtil/response_wrappers.dart';
import 'package:filter/injection_container.dart';
import 'package:filter/utils/global_function.dart';
import 'package:filter/utils/navigation_service.dart';
import 'package:filter/view/commonWidgets/image_source_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

import 'package:permission_handler/permission_handler.dart';

import '../common/images.dart';
import '../infrastructure/apiUtil/urls.dart';
import '../infrastructure/catalog_facade_service.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this.catalogFacadeService});
  final CatalogFacadeService catalogFacadeService;

  XFile _selectedFile = XFile("");
  XFile get selectedFile => _selectedFile;

  int _typeOfFilter = 1;
  int get typeOfFilter => _typeOfFilter;

  String _filterName = "Filters";
  String get filterName => _filterName;

  int _selectedFilter = 1;
  int get selectedFilter => _selectedFilter;

  String _processedImage = "";
  String get processedImage => _processedImage;

  Uint8List? _imageBytes;
  Uint8List? get imageBytes => _imageBytes;

  bool _isApplyingFilter = false;
  bool get isApplyingFilter => _isApplyingFilter;

  bool _seeOldPicture = false;
  bool get seeOldPicture => _seeOldPicture;

  final List<Map<String, String>> _filters = [
    {"filter": Filters.normalImage, "name": "Normal"},
    {"filter": Filters.removebg, "name": "Remove BG"},
    {"filter": Filters.popup_red, "name": "PopUp Red"},
    {"filter": Filters.grayscale, "name": "Gray Scale"},
    {"filter": Filters.colorisation_cold, "name": "Colorise 1"},
    {"filter": Filters.colorisation_warm, "name": "Colorise 2"},
    {"filter": Filters.sepia, "name": "Sepia"},
    {"filter": Filters.sketch_3, "name": "Sketch 1"},
    {"filter": Filters.sketch_5, "name": "Sketch 2"},
    {"filter": Filters.sketch_8, "name": "Sketch 3"},
    {"filter": Filters.sketch_12, "name": "Sketch 4"},
    {"filter": Filters.sketch_16, "name": "Sketch 5"},
    {"filter": Filters.sketch_32, "name": "Sketch 6"},
    {"filter": Filters.vintage_old1, "name": "Vintage 1"},
    {"filter": Filters.vintage_old1n, "name": "Vintage 1n"},
    {"filter": Filters.vintage_old2, "name": "Vintage 2"},
    {"filter": Filters.vintage_old2n, "name": "Vintage 2n"},
    {"filter": Filters.vintage_old3, "name": "Vintage 3"},
    {"filter": Filters.vintage_old3n, "name": "Vintage 3n"},
    {"filter": Filters.vintage_old4, "name": "Vintage 4"},
    {"filter": Filters.vintage_old4n, "name": "Vintage 4n"},
    {"filter": Filters.vintage_old5, "name": "Vintage 5"},
    {"filter": Filters.vintage_old5n, "name": "Vintage 5n"},
    {"filter": Filters.vintage_old6, "name": "Vintage 6"},
    {"filter": Filters.vintage_old6n, "name": "Vintage 6n"},
    {"filter": Filters.vintage_old7, "name": "Vintage 7"},
    {"filter": Filters.vintage_old7n, "name": "Vintage 7n"},

    // {"filter": Filters.grayScale, "name": "Grey Scale"},
    // {"filter": Filters.artistic, "name": "Artistic"},
    // {"filter": Filters.lighting, "name": "Lighting"},
    // {"filter": Filters.love, "name": "Love"},
    // {"filter": Filters.highExposure, "name": "Exposure"},
    // {"filter": Filters.orange, "name": "Orange"},
    // {"filter": Filters.sepia, "name": "Sepia"},
    // {"filter": Filters.vintage, "name": "Vintage"},
  ];
  List<Map<String, String>> get filters => _filters;

  final List<Map<String, String>> _aiFilters = [
    {"filter": Filters.normalImage, "name": "add"},
    {"filter": Filters.normalImage, "name": "Normal"},
    {"filter": AiFilters.superman, "name": "Superman"},
    {"filter": AiFilters.catFace, "name": "Cat Face"},
    {"filter": AiFilters.tigerFace, "name": "Tiger Face"},
  ];
  List<Map<String, String>> get aiFilters => _aiFilters;

  void applyingFilter(bool loading) {
    _isApplyingFilter = loading;
    notifyListeners();
  }

  set memoryImageBytes(Uint8List? bytes) {
    _imageBytes = bytes;
    notifyListeners();
  }

  void changePictureView(bool value) {
    _seeOldPicture = value;
    notifyListeners();
  }

  void addProcessedImage(String imagePath) {
    _processedImage = imagePath;
    notifyListeners();
  }

  void changeFilterType(int type) {
    _typeOfFilter = type;
    _typeOfFilter == 0
        ? _filterName = ""
        : _typeOfFilter == 1
            ? _filterName = "Filters"
            : _filterName = "Ai Filters";
    notifyListeners();
  }

  void selectFilter(int index) {
    _selectedFilter = index;
    notifyListeners();
  }

  void removeImage() {
    _selectedFile = XFile("");
    _processedImage = "";
    _typeOfFilter = 1;
    notifyListeners();
  }

  Future<void> requestPermissions(BuildContext context) async {
    final statuses = await [
      Permission.camera,
      Permission.photos,
    ].request();

    if ((statuses[Permission.camera]!.isGranted &&
            statuses[Permission.photos]!.isGranted) ||
        (statuses[Permission.camera]!.isLimited &&
            statuses[Permission.photos]!.isLimited)) {
      _showImageSourceDialog(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Permissions are required to pick an image')),
      );
    }
  }

  Future<bool> _requestMediaPermission() async {
    PermissionStatus status = await Permission.photos.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied || status.isLimited) {
      status = await Permission.photos.request();
      if (status.isGranted || status.isLimited) {
        return true;
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return false;
  }

  Future<void> saveImageToStorage() async {
    try {
      if (await _requestMediaPermission()) {
        Uint8List? imageData;

        // Öncelikle processedImage'in geçerli olup olmadığını kontrol et
        if (_imageBytes != null) {
          imageData = _imageBytes!;
        } else if (_processedImage.isNotEmpty) {
          try {
            final ByteData byteData = await rootBundle.load(_processedImage);
            imageData = byteData.buffer.asUint8List();
          } catch (e) {
            print("Failed to load _processedImage: $e");
          }
        }

        // Eğer _imageBytes null değilse, onu kullanın

        // Eğer imageData hala null ise, hata fırlatın
        if (imageData == null) {
          throw Exception("No image data available to save.");
        }

        // Resmi galeriye kaydet
        final result = await ImageGallerySaver.saveImage(imageData,
            quality: 100, name: "sample_image");

        if (result['isSuccess']) {
          showToast(
              message: "Image saved to the Gallery",
              context: NavigationService.navigatorKey.currentContext!);
        } else {
          showToast(
              message: "Failed to save the image",
              context: NavigationService.navigatorKey.currentContext!);
        }
      } else {
        showToast(
            message: "Permission Denied!",
            context: NavigationService.navigatorKey.currentContext!);
      }
    } catch (e) {
      showToast(
          message: "Saving error: $e",
          context: NavigationService.navigatorKey.currentContext!);
      print("Saving error: $e");
    }
  }

  Future<void> _showImageSourceDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const ImageSourceDialog(),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _selectedFile = pickedFile;
      _processedImage = "";
      _typeOfFilter = 1;
      catalogFacadeService.registerService(
        image: _selectedFile,
      );
      _imageBytes = null;
      notifyListeners();
      Navigator.pop(NavigationService.navigatorKey.currentContext!);
    }
  }

  void registerService() async {
    try {
      Urls.sessionId = getRandomString(28);
      var res = await catalogFacadeService.registerService(
        image: _selectedFile,
      );
      print(res.status);
      if (res.message!.isNotEmpty) {
        showToast(
          message: res.message!,
          context: NavigationService.navigatorKey.currentContext!,
        );
        return;
      }
      final responseData = res.data!;
      if (responseData.isEmpty) {
        return;
      }
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      print(e);
      showToast(
        message: "Something went wrong $e",
        context: NavigationService.navigatorKey.currentContext!,
      );
    }
  }

  Future<void> applyFilter({required String filterName}) async {
    late ResponseWrapper<dynamic> res;
    try {
      res = await catalogFacadeService.applyFilter(filterName: filterName);
    } catch (e) {
      showToast(
        message: res.message ?? "An error occurred",
        context: NavigationService.navigatorKey.currentContext!,
      );
    }

    await applyFilterAll(res);
  }

  Future<void> applyAiFilter({required String aiFilterName}) async {
    late ResponseWrapper<dynamic> res;
    try {
      res =
          await catalogFacadeService.applyAiFilter(aiFilterName: aiFilterName);
    } catch (e) {
      showToast(
        message: res.message ?? "An error occurred",
        context: NavigationService.navigatorKey.currentContext!,
      );
    }

    await applyFilterAll(res);
  }

  Future<void> applyFilterAll(ResponseWrapper<dynamic> res) async {
    try {
      print('Response Status: ${res.status}');
      if (res.status == null || res.status != 200) {
        print('Error: Status is not 200 or status is null');
        showToast(
          message: res.message ?? "An error occurred",
          context: NavigationService.navigatorKey.currentContext!,
        );
      }

      // Data controll  for is avaible for using &  write path
      if (res.data != null) {
        print('Response Data: Data is not null');
        if (res.data is Uint8List) {
          print('Response Data Type: Uint8List');
          final directory = await getTemporaryDirectory();
          print('Temporary Directory Path: ${directory.path}');
          try {
            _imageBytes = res.data;
            const String fileName = 'memory2.jpg';
            final filePath = join(directory.path, fileName);
            final file = File(filePath);
            await file.writeAsBytes(_imageBytes!);
            print('File saved successfully at: $filePath');
            _processedImage = filePath;
          } catch (e) {
            print('Error: Failed to write file: $e');
            showToast(
              message: "Failed to write file: $e",
              context: NavigationService.navigatorKey.currentContext!,
            );
          }
        } else {
          print('Error: Data is not in expected format (Uint8List expected)');
          showToast(
            message: "Data is not in expected format. Expected Uint8List.",
            context: NavigationService.navigatorKey.currentContext!,
          );
        }
      } else {
        print('Error: No data received');
        showToast(
          message: "No data received.",
          context: NavigationService.navigatorKey.currentContext!,
        );
      }
    } on DioException catch (e) {
      print('DioError occurred: $e');
      handleDioError(e);
    } catch (e) {
      print('Exception occurred: $e');
      showToast(
        message: "Something went wrong: $e",
        context: NavigationService.navigatorKey.currentContext!,
      );
    }
  }
}
