import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myapp/constants/api_constants.dart';
import 'package:myapp/services/token_service.dart';

class FriendService {
  static Future<List<Map<String, dynamic>>> fetchFriends() async {
    final token = await TokenService.getToken();
    if (token == null) {
      print('You need to login!');
      return [];
    }

    final endPoint = '/message/list-friend';
    final url = Uri.parse(ApiConstants.getUrl(endPoint));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      final status = body['status'];
      if(status != null && status == 1){
        List<dynamic> rawList = body['data'];
        return rawList.cast<Map<String, dynamic>>();
      }else{
        print('Lỗi API: ${body['message']}');
      }
    }else{
      print('Lỗi server: ${response.statusCode}');
    }
    return [];
  }
}
