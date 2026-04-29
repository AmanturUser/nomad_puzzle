import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/errors/exceptions.dart';

abstract class CameraDataSource {
  Future<bool> requestPermission();
  Future<String?> takePhoto();
  Future<String?> pickFromGallery();
}

@LazySingleton(as: CameraDataSource)
class CameraDataSourceImpl implements CameraDataSource {
  CameraDataSourceImpl(this._picker);

  final ImagePicker _picker;

  @override
  Future<bool> requestPermission() async {
    final status = await Permission.camera.request();
    if (status.isPermanentlyDenied) {
      throw const PermissionException('Camera permission permanently denied');
    }
    return status.isGranted;
  }

  @override
  Future<String?> takePhoto() async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    return file?.path;
  }

  @override
  Future<String?> pickFromGallery() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    return file?.path;
  }
}
