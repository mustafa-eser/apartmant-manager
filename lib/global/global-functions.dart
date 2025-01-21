import 'dart:io';

import 'package:images_picker/images_picker.dart';

import '../index.dart';
import 'index.dart';

class GlobalFunction {
  Future getItInital() async {
    if (!GetIt.I.isRegistered<GlobalService>()) {
      GetIt.I.registerSingleton<GlobalService>(GlobalService());
    }
    if (!GetIt.I.isRegistered<ExpensesService>()) {
      GetIt.I.registerSingleton<ExpensesService>(ExpensesService());
    }
    if (!GetIt.I.isRegistered<ManagerService>()) {
      GetIt.I.registerSingleton<ManagerService>(ManagerService());
    }
  }

  Future<File?> filePathToFile(String path) async {
    try {
      File file = File(path);

      if (await file.exists()) {
        return file;
      }
      print('File does not exist at the specified path.');
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<File?> selectImageFromCamera() async {
    try {
      List<Media>? files = await ImagesPicker.openCamera(pickType: PickType.image);
      if (files != null && files.length == 1) {
        return await filePathToFile(files.first.path);
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<File?> selectImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? file = await picker.pickImage(source: ImageSource.gallery);

      if (file != null) {
        print("Image selected: ${file.path}");
        return File(file.path);
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error selecting image: $e");
      return null;
    }
  }
}
