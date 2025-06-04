import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService{
  static Future<void> downloadFile(String fileUrl, String fileName) async {
    try {
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          print('Permission denied');
          return;
        }
      }

      // Lấy thư mục lưu
      Directory dir = Platform.isAndroid
          ? Directory('/storage/emulated/0/Download') // Android
          : await getApplicationDocumentsDirectory(); // iOS

      String savePath = '${dir.path}/$fileName';

      // Tải bằng Dio
      Dio dio = Dio();
      await dio.download(fileUrl, savePath);

      print('Downloaded to: $savePath');
    } catch (e) {
      print('Download error: $e');
    }
  }
}