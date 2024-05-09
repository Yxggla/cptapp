import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<void> takePicture() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final File temporaryImage = File(pickedFile.path);
        final Directory appDir = await getApplicationDocumentsDirectory();
        final Directory targetDirectory = Directory('${appDir.path}/MyPictures');

        // 确保目标目录存在
        if (!await targetDirectory.exists()) {
          await targetDirectory.create(recursive: true);  // 创建目录
        }

        final String filePath = '${targetDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final File savedImage = await temporaryImage.copy(filePath);

        print("图片已保存到: $filePath");
      } else {
        print('未拍摄任何照片。');
      }
    } catch (e) {
      print('拍摄失败: $e');
    }
  }
}
