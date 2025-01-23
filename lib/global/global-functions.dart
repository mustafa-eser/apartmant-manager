import 'dart:io';
import 'package:image_picker/image_picker.dart'; // Changed to image_picker
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
      final ImagePicker picker =
          ImagePicker(); // ImagePicker instance for camera
      final XFile? file = await picker.pickImage(source: ImageSource.camera);

      if (file != null) {
        return await filePathToFile(
            file.path); // Return the image file from the camera
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<File?> selectImageFromGallery() async {
    try {
      final ImagePicker picker =
          ImagePicker(); // ImagePicker instance for gallery
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);

      if (file != null) {
        print("Image selected: ${file.path}");
        return File(file.path); // Return the selected image file
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error selecting image: $e");
      return null;
    }
    return null;
  }
}
