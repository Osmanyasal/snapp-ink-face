import 'package:dio/dio.dart';
import 'package:filter/infrastructure/apiUtil/response_wrappers.dart';

import 'package:filter/utils/global_function.dart';
import 'package:filter/utils/navigation_service.dart';
import 'package:filter/view/commonWidgets/image_source_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:permission_handler/permission_handler.dart';
import '../common/images.dart';
import '../infrastructure/catalog_facade_service.dart';
import '../view/commonWidgets/filter_dialog.dart';

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
    // {"filter": Filters.normalImage, "name": "Normal"},

    {"filter": AiFilters.face_swap_adventure_1, "name": "Adventure"}, 
    {"filter": AiFilters.face_swap_adventure_2, "name": "Adventure"}, 
    {"filter": AiFilters.face_swap_adventure_3, "name": "Adventure"}, 
    {"filter": AiFilters.face_swap_adventure_4, "name": "Adventure"}, 
    {"filter": AiFilters.face_swap_adventure_5, "name": "Adventure"}, 
    {"filter": AiFilters.face_swap_adventure_6, "name": "Adventure"}, 
    {"filter": AiFilters.face_swap_adventure_7, "name": "Adventure"}, 
    {"filter": AiFilters.face_swap_adventure_8, "name": "Adventure"}, 
    {"filter": AiFilters.face_swap_adventure_9, "name": "Adventure"}, 

    {"filter": AiFilters.face_swap_beach_1, "name": "Beach"}, 
    {"filter": AiFilters.face_swap_beach_2, "name": "Beach"}, 
    {"filter": AiFilters.face_swap_beach_3, "name": "Beach"}, 
    {"filter": AiFilters.face_swap_beach_4, "name": "Beach"}, 
    {"filter": AiFilters.face_swap_beach_5, "name": "Beach"}, 
    {"filter": AiFilters.face_swap_beach_6, "name": "Beach"}, 

    {"filter": AiFilters.face_swap_business_1, "name": "Beach"},
    {"filter": AiFilters.face_swap_business_2, "name": "Beach"},
    {"filter": AiFilters.face_swap_business_3, "name": "Beach"},
    {"filter": AiFilters.face_swap_business_4, "name": "Beach"},
    {"filter": AiFilters.face_swap_business_5, "name": "Beach"},
    {"filter": AiFilters.face_swap_business_6, "name": "Beach"}, 
    {"filter": AiFilters.face_swap_business_7, "name": "Beach"}, 
    {"filter": AiFilters.face_swap_business_8, "name": "Beach"}, 

    {"filter": AiFilters.face_swap_fantasy_1, "name": "Fantasy"}, 
    {"filter": AiFilters.face_swap_fantasy_2, "name": "Fantasy"}, 
    {"filter": AiFilters.face_swap_fantasy_3, "name": "Fantasy"}, 
    {"filter": AiFilters.face_swap_fantasy_4, "name": "Fantasy"}, 
    {"filter": AiFilters.face_swap_fantasy_5, "name": "Fantasy"}, 
    {"filter": AiFilters.face_swap_fantasy_6, "name": "Fantasy"}, 
    {"filter": AiFilters.face_swap_fantasy_7, "name": "Fantasy"}, 
    {"filter": AiFilters.face_swap_fantasy_8, "name": "Fantasy"}, 

    {"filter": AiFilters.face_swap_gym_1, "name": "Gym"},
    {"filter": AiFilters.face_swap_gym_2, "name": "Gym"},
    {"filter": AiFilters.face_swap_gym_3, "name": "Gym"},
    {"filter": AiFilters.face_swap_gym_4, "name": "Gym"},
    {"filter": AiFilters.face_swap_gym_5, "name": "Gym"},
    {"filter": AiFilters.face_swap_gym_6, "name": "Gym"},
    {"filter": AiFilters.face_swap_gym_7, "name": "Gym"},
    {"filter": AiFilters.face_swap_gym_8, "name": "Gym"}, 

    {"filter": AiFilters.face_swap_heros_1, "name": "Heros"},
    {"filter": AiFilters.face_swap_heros_2, "name": "Heros"},
    {"filter": AiFilters.face_swap_heros_3, "name": "Heros"},
    {"filter": AiFilters.face_swap_heros_4, "name": "Heros"},
    {"filter": AiFilters.face_swap_heros_5, "name": "Heros"},
    {"filter": AiFilters.face_swap_heros_6, "name": "Heros"},
    {"filter": AiFilters.face_swap_heros_7, "name": "Heros"},

    {"filter": AiFilters.face_swap_hippie_1, "name": "Hippie"},
    {"filter": AiFilters.face_swap_hippie_2, "name": "Hippie"},
    {"filter": AiFilters.face_swap_hippie_3, "name": "Hippie"},
    {"filter": AiFilters.face_swap_hippie_4, "name": "Hippie"},
    {"filter": AiFilters.face_swap_hippie_5, "name": "Hippie"},
    {"filter": AiFilters.face_swap_hippie_6, "name": "Hippie"},

    {"filter": AiFilters.face_swap_postmodern_1, "name": "Postmodern"},
    {"filter": AiFilters.face_swap_postmodern_2, "name": "Postmodern"},
    {"filter": AiFilters.face_swap_postmodern_3, "name": "Postmodern"},
    {"filter": AiFilters.face_swap_postmodern_4, "name": "Postmodern"},
    {"filter": AiFilters.face_swap_postmodern_5, "name": "Postmodern"},
    {"filter": AiFilters.face_swap_postmodern_6, "name": "Postmodern"},
    {"filter": AiFilters.face_swap_postmodern_7, "name": "Postmodern"},
    {"filter": AiFilters.face_swap_postmodern_8, "name": "Postmodern"},

    {"filter": AiFilters.face_swap_punk_1, "name": "Punk"},
    {"filter": AiFilters.face_swap_punk_2, "name": "Punk"},
    {"filter": AiFilters.face_swap_punk_3, "name": "Punk"},
    {"filter": AiFilters.face_swap_punk_4, "name": "Punk"},

    {"filter": AiFilters.face_swap_rogue_1, "name": "Rogue"},
    {"filter": AiFilters.face_swap_rogue_2, "name": "Rogue"},
    {"filter": AiFilters.face_swap_rogue_3, "name": "Rogue"},
    {"filter": AiFilters.face_swap_rogue_4, "name": "Rogue"},
    {"filter": AiFilters.face_swap_rogue_5, "name": "Rogue"},
    {"filter": AiFilters.face_swap_rogue_6, "name": "Rogue"},
    {"filter": AiFilters.face_swap_rogue_7, "name": "Rogue"},
    {"filter": AiFilters.face_swap_rogue_8, "name": "Rogue"},

    {"filter": AiFilters.face_swap_space_1, "name": "Space"},
    {"filter": AiFilters.face_swap_space_2, "name": "Space"},
    {"filter": AiFilters.face_swap_space_3, "name": "Space"},
    {"filter": AiFilters.face_swap_space_4, "name": "Space"},
    {"filter": AiFilters.face_swap_space_5, "name": "Space"},
    {"filter": AiFilters.face_swap_space_6, "name": "Space"},
    {"filter": AiFilters.face_swap_space_7, "name": "Space"},

    {"filter": AiFilters.face_swap_sports_1, "name": "Sports"},
    {"filter": AiFilters.face_swap_sports_2, "name": "Sports"},
    {"filter": AiFilters.face_swap_sports_3, "name": "Sports"},
    {"filter": AiFilters.face_swap_sports_4, "name": "Sports"},
    {"filter": AiFilters.face_swap_sports_5, "name": "Sports"},
    {"filter": AiFilters.face_swap_sports_6, "name": "Sports"},
    {"filter": AiFilters.face_swap_sports_7, "name": "Sports"},

    {"filter": AiFilters.face_swap_yellow_1, "name": "Yellow"},
    {"filter": AiFilters.face_swap_yellow_2, "name": "Yellow"},
    {"filter": AiFilters.face_swap_yellow_3, "name": "Yellow"},
    {"filter": AiFilters.face_swap_yellow_4, "name": "Yellow"},
    {"filter": AiFilters.face_swap_yellow_5, "name": "Yellow"},
    {"filter": AiFilters.face_swap_yellow_6, "name": "Yellow"},
    {"filter": AiFilters.face_swap_yellow_7, "name": "Yellow"},
    {"filter": AiFilters.face_swap_yellow_8, "name": "Yellow"},
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

   Uint8List? shortMemoryPic;
  void changePictureView(bool value) {
    _seeOldPicture = value;
    if (_seeOldPicture) {
      shortMemoryPic = _imageBytes;
      _imageBytes = null;
    } else {
      _imageBytes = shortMemoryPic;
    }

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

  Future<void> requestPermissions(
      BuildContext context, bool aiFilterAddPhotoButton) async {
    final statuses = await [
      Permission.camera,
      Permission.photos,
      Permission.mediaLibrary,
    ].request();

    final cameraGranted = statuses[Permission.camera]?.isGranted ?? false;
    final photosGranted = statuses[Permission.photos]?.isGranted ?? false;

    if (cameraGranted || photosGranted) {
      _showImageSourceDialog(context, aiFilterAddPhotoButton);
    } else {
      if (statuses[Permission.camera]?.isPermanentlyDenied ??
          false || statuses[Permission.photos]!.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enable permissions from settings'),
            action: SnackBarAction(
              label: 'Open Settings',
              onPressed: () {
                openAppSettings();
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permissions are required to pick an image'),
          ),
        );
      }
    }
  }

  Future<bool> _requestMediaPermission() async {
    final status = await Permission.photos.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied || status.isLimited) {
      final newStatus = await Permission.photos.request();
      return newStatus.isGranted || newStatus.isLimited;
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

  Future<void> _showImageSourceDialog(
      BuildContext context, bool aiFilterAddPhotoButton) async {
    showDialog(
      context: context,
      builder: (context) => ImageSourceDialog(
        aiFilterAddPhotoButton: aiFilterAddPhotoButton,
      ),
    );
  }

  Future<void> pickImage(
      ImageSource source, bool aiFilterAddPhotoButton) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _selectedFile = pickedFile;
      if (aiFilterAddPhotoButton) {
        Navigator.pop(NavigationService.navigatorKey.currentContext!);
        applyingFilter(true);
        showDialog(
            context: NavigationService.navigatorKey.currentContext!,
            builder: (context) {
              return WidgetDialog(
                content: const SizedBox(
                  height: 350,
                  width: 350,
                ), // for ads unneccassery someone widget
                title: 'Applying ia filter',
              );
            });
        _typeOfFilter = 0;

        try {
          await catalogFacadeService.registerAiService(
            image: _selectedFile,
          );
          var res = await catalogFacadeService.applyAiFilter(
            aiFilterName: 'custom',
          );
          _imageBytes = res.data;
        } catch (e) {
          showToast(
            message: "An error occurred : ${e.toString()}",
            context: NavigationService.navigatorKey.currentContext!,
          );
        }
        await Future.delayed(
            const Duration(seconds: 2)); // for ads showing duration
        applyingFilter(false);
        Navigator.pop(NavigationService.navigatorKey.currentContext!);
      } else {
        _imageBytes = null;
        _processedImage = "";
        _typeOfFilter = 1;
        catalogFacadeService.registerService(
          image: _selectedFile,
        );
        notifyListeners();
        Navigator.pop(NavigationService.navigatorKey.currentContext!);
      }
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
          _imageBytes = res.data;
          print('Response Data Type: Uint8List');
          final directory = await getTemporaryDirectory();
          print('Temporary Directory Path: ${directory.path}');
          try {} catch (e) {
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
