import 'package:dio/dio.dart';
import 'package:filter/utils/global_function.dart';
import 'package:filter/utils/navigation_service.dart';
import 'package:filter/view/commonWidgets/image_source_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/images.dart';
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

  bool _isApplyingFilter = false;
  bool get isApplyingFilter => _isApplyingFilter;

  bool _seeOldPicture = false;
  bool get seeOldPicture => _seeOldPicture;

  final List<Map<String, String>> _filters = [
    {"filter": Filters.normalImage, "name": "add"},

    {"filter": Filters.vintage_old1, "name": "Vintage-1"},
    {"filter": Filters.vintage_old1n, "name": "Vintage-1n"},
    {"filter": Filters.vintage_old2, "name": "Vintage-2"},
    {"filter": Filters.vintage_old2n, "name": "Vintage-2n"},
    {"filter": Filters.vintage_old3, "name": "Vintage-3"},
    {"filter": Filters.vintage_old3n, "name": "Vintage-3n"},
    {"filter": Filters.vintage_old4, "name": "Vintage-4"},
    {"filter": Filters.vintage_old4n, "name": "Vintage-4n"},
    {"filter": Filters.vintage_old5, "name": "Vintage-5"},
    {"filter": Filters.vintage_old5n, "name": "Vintage-5n"},
    {"filter": Filters.vintage_old6, "name": "Vintage-6"},
    {"filter": Filters.vintage_old6n, "name": "Vintage-6n"},
    {"filter": Filters.vintage_old7, "name": "Vintage-7"},
    {"filter": Filters.vintage_old7n, "name": "Vintage-7n"},

    {"filter": Filters.normalImage, "name": "Normal"},
    {"filter": Filters.grayScale, "name": "Grey Scale"},
    {"filter": Filters.artistic, "name": "Artistic"},
    {"filter": Filters.lighting, "name": "Lighting"},
    {"filter": Filters.love, "name": "Love"},
    {"filter": Filters.highExposure, "name": "Exposure"},
    {"filter": Filters.orange, "name": "Orange"},
    {"filter": Filters.sepia, "name": "Sepia"},
    {"filter": Filters.vintage, "name": "Vintage"},
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
        final ByteData byteData = await rootBundle.load(_processedImage);
        final Uint8List imageData = byteData.buffer.asUint8List();

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
          message: "Saving error!",
          context: NavigationService.navigatorKey.currentContext!);
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
      notifyListeners();
      Navigator.pop(NavigationService.navigatorKey.currentContext!);
    }
  }

  void registerService() async {
    try {
      final sessionId = getRandomString(28);
      var res = await catalogFacadeService.registerService(
        image: _selectedFile,
        sessionId: sessionId,
      );
      if (res.status!.contains('error')) {
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
      showToast(
        message: "Something went wrong $e",
        context: NavigationService.navigatorKey.currentContext!,
      );
    }
  }
}
