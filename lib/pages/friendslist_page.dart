import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/online_chat.dart';

import '../constants/api_constants.dart';
import '../constants/color_constants.dart';

late Size mq;
class FriendsList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyWidget();
  }
}

class MyWidget extends State<FriendsList>{
  final TextEditingController _searchController = TextEditingController();
  final List<String> friendsList = ['Bạn A', 'Bạn B', 'Bạn C', 'Bạn D', 'Bạn E', 'Bạn F',
    'Bạn A1', 'Bạn B1', 'Bạn C1', 'Bạn D1', 'Bạn E1', 'Bạn F1',
    'Bạn A2', 'Bạn B2', 'Bạn C2', 'Bạn D2', 'Bạn E2', 'Bạn F2',
    'Bạn A3', 'Bạn B3', 'Bạn C3', 'Bạn D3', 'Bạn E3', 'Bạn F3'];
  final String avatarUrl =
      'https://th.bing.com/th/id/OIP.dIF3iIIIuK5HeBCq_aoxZwHaH8?rs=1&pid=ImgDetMain';
  void _clearSearch(){
    _searchController.clear();
  }
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false, //đảm bảo phần body không vẽ ra sau appbar để tránh xung đột màu
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // elevation: 0,
        title: Text(
          'Bkav Chat',
          style: TextStyle(
            color: ColorConstants.logoColor,
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [ //chứa widget nằm ở cuối( bên phải) của appBar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://th.bing.com/th/id/OIP.Ver1XHdydULpiJD6Sq1gBgHaHS?rs=1&pid=ImgDetMain'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(mq.width * .03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //thanh tìm kiếm
              Container(
                  width: mq.width * .8,
                  height: mq.height * .055,
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F6F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // padding:const EdgeInsets.symmetric(horizontal: 35),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    decoration: InputDecoration(
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 10.0,),
                        child: Icon(
                          Icons.search,
                          size: 35,
                        ),
                      ),
                      border: InputBorder.none,
                      hintText: 'Tìm kiếm',
                      hintStyle: TextStyle(fontSize: 12),
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      suffixIcon: GestureDetector( //bắt sự kiện khi người dùng click vào icon
                        onTap: _clearSearch,
                        child: Icon(
                          Icons.close,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: mq.height * .025,),
              Center(
                child: const Text(
                  'Danh sách bạn bè',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: mq.height * .025,),
              Expanded(
                  child: ListView.builder(
                    itemCount: friendsList.length,
                    // physics: BouncingScrollPhysics(),//hiệu ứng cuộn 'giật nhẹ lại'
                    itemBuilder: (context, index) => FriendTile(name: friendsList[index], avatarUrl: avatarUrl),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FriendTile extends StatelessWidget{
  final String name;
  final String avatarUrl;

  const FriendTile({super.key, required this.name, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OnlineChat(name: 'Ban X',avatarUrl: 'https://th.bing.com/th/id/OIP.Ver1XHdydULpiJD6Sq1gBgHaHS?rs=1&pid=ImgDetMain',))
        );
      },
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
            radius: 24,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.green,
                // borderRadius: BorderRadius.circular(24.0),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white,),
              ),
            ),
          )
        ],
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 40.0),
        child: Text(name),
      ),
    );
  }
}
Future<bool> getUserInfo() async{
  String urlPath = ApiConstants.getUrl('/auth/login');
  final uri = Uri.parse(urlPath);

  return true;
}