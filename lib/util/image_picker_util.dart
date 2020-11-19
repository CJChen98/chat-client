import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  static Future<PickedFile> pick() async {
    return await ImagePicker.platform.pickImage(source: ImageSource.gallery);
  }
}
