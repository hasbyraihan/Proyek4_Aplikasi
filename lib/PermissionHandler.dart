import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  Future<void> requestPermissions() async {
    // Untuk Android 7 - Android 9
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }

    // Untuk Android 11 ke atas (API 30+), gunakan MANAGE_EXTERNAL_STORAGE
    // if (await Permission.manageExternalStorage.isDenied) {
    //   final status = await Permission.manageExternalStorage.request();
    //   if (status.isDenied ||
    //       status.isPermanentlyDenied ||
    //       status.isRestricted) {
    //     throw "Please allow storage permission to upload files";
    //   }
    // }

    // Untuk Android 13+ (API 33+), izin untuk akses gambar, video, atau audio
    if (await Permission.photos.isDenied) {
      await Permission.photos.request();
    }

    if (await Permission.videos.isDenied) {
      await Permission.videos.request();
    }
  }

  void checkPermissions() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await requestPermissions();
    }
  }
}
