import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:myapp/services/token_service.dart';

import '../constants/api_constants.dart';
import '../models/message.dart';

class MessageService {
  static Future<List<Message>> fetchMessages(String friendId) async {
    final token = await TokenService.getToken();
    if (token == null) {
      print('You need to login!');
      return [];
    }

    final endPoint = '/message/get-message?FriendID=$friendId';
    final url = Uri.parse(ApiConstants.getUrl(endPoint));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final status = body['status'];
      if (status != null && status == 1) {
        final List<dynamic> rawList = body['data'];
        return rawList
            .map((item) => Message.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        print('Lỗi API: ${body['message']}');
      }
    } else {
      print('Lỗi server: ${response.statusCode}');
    }
    return [];
  }

  static Future<Message?> sendMessage({
    required String friendId,
    String? content,
    List<File>? imageFiles,
    List<File>? otherFiles,
  }) async {
    final token = await TokenService.getToken();
    if (token == null) {
      print('You need to login!');
      return null;
    }

    final endPoint = '/message/send-message';
    final url = Uri.parse(ApiConstants.getUrl(endPoint));
    var request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['FriendID'] = friendId;

    if (content != null && content.isNotEmpty) {
      request.fields['Content'] = content;
    }

    // Gửi ảnh
    if (imageFiles != null) {
      for (var image in imageFiles) {
        var stream = http.ByteStream(image.openRead());
        var length = await image.length();
        var multipartFile = http.MultipartFile(
          'Images',
          stream,
          length,
          filename: path.basename(image.path),
        );
        request.files.add(multipartFile);
      }
    }

    // Gửi file
    if (otherFiles != null) {
      for (var file in otherFiles) {
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();
        var multipartFile = http.MultipartFile(
          'Files',
          stream,
          length,
          filename: path.basename(file.path),
        );
        request.files.add(multipartFile);
      }
    }

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final jsonResp = jsonDecode(respStr);

        if (jsonResp['status'] == 1) {
          return Message.fromJson(jsonResp['data']);
        } else {
          print('Send failed: ${jsonResp['message']}');
        }
      } else {
        print('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception sending message: $e');
    }

    return null;
  }
}
