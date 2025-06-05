import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants/api_constants.dart';
import 'package:myapp/pages/login_page.dart';
import 'package:myapp/pages/online_chat.dart';
import 'package:myapp/services/token_service.dart';
import 'package:myapp/services/user_storage.dart';

import '../constants/api_constants.dart';
import '../constants/color_constants.dart';
import '../services/friend_service.dart';

late Size mq;

class FriendsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHome();
  }
}

class MyHome extends State<FriendsList> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> friendsList = [];
  List<Map<String, dynamic>> originalFriendsList = [];
  Map<String, dynamic>? currentUser;
  void _clearSearch() {
    _searchController.clear();
  }

  void loadCurrentUser() async {
    final userInfo = await UserStorage.fetchUserInfo();
    if (userInfo != null) {
      setState(() {
        currentUser = userInfo;
      });
    }
  }

  void loadFriends() async {
    final friends = await FriendService.fetchFriends();
    setState(() {
      friendsList = friends;
      originalFriendsList = friends;
    });
  }

  void _onSearchChanged() {
    setState(() {
      friendsList = FriendService.filterFriends(
        originalFriendsList,
        _searchController.text,
      );
    });
  }

  void _logout(BuildContext context) async {
    // Xóa thông tin người dùng đã lưu
    await TokenService.clearToken();

    // Chuyển hướng về trang đăng nhập
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
    loadFriends();
    _searchController.addListener(() {
      _onSearchChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar:
          false, //đảm bảo phần body không vẽ ra sau appbar để tránh xung đột màu
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
        actions: [
          //chứa widget nằm ở cuối( bên phải) của appBar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  _logout(context);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Đăng xuất'),
                  ),
                ];
              },
              child: CircleAvatar(
                child: CircleAvatar(
                  backgroundImage:
                      (currentUser != null && currentUser!['Avatar'] != null)
                          ? NetworkImage(
                            ApiConstants.getUrl(currentUser!['Avatar']),
                          )
                          : const AssetImage('assets/images/no_avatar.jpg')
                              as ImageProvider,
                ),
              ),
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
                  style: TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Icon(Icons.search, size: 35),
                    ),
                    border: InputBorder.none,
                    hintText: 'Tìm kiếm',
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                    suffixIcon: GestureDetector(
                      //bắt sự kiện khi người dùng click vào icon
                      onTap: _clearSearch,
                      child: Icon(Icons.close, size: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: mq.height * .025),
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
              SizedBox(height: mq.height * .025),
              Expanded(
                child: ListView.builder(
                  itemCount: friendsList.length,
                  // physics: BouncingScrollPhysics(),//hiệu ứng cuộn 'giật nhẹ lại'
                  itemBuilder: (context, index) {
                    final friend = friendsList[index];
                    String? content = friend['Content'];
                    final files = friend['Files'];
                    final images = friend['Images'];

                    if (files != null) {
                      content = 'Đã gửi file cho bạn!';
                    } else if (images != null) {
                      content = 'Đã gửi ảnh cho bạn!';
                    } else if (content == '' &&
                        files == null &&
                        images == null) {
                      content = 'Hãy bắt đầu cuộc trò chuyện';
                    }
                    final name = friend['FullName'] ?? 'No Name';
                    final avatar =
                        (friend['Avatar'] != null)
                            ? ApiConstants.getUrl(friend['Avatar'])
                            : 'https://static2.yan.vn/YanNews/2167221/202102/facebook-cap-nhat-avatar-doi-voi-tai-khoan-khong-su-dung-anh-dai-dien-e4abd14d.jpg';
                    final isOnline = friend['isOnline'];
                    final friendId = friend['FriendID'];
                    final isSend = friend['isSend'];
                    return FriendTile(
                      name: name,
                      avatarUrl: avatar,
                      isOnline: isOnline,
                      friendID: friendId,
                      content: content,
                      isSend: isSend,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FriendTile extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final String friendID;
  final String? content;
  final int isSend;

  const FriendTile({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.isOnline,
    required this.friendID,
    required this.content,
    required this.isSend,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => OnlineChat(
                  name: name,
                  avatarUrl: avatarUrl,
                  friendId: friendID,
                  isOnline: isOnline,
                ),
          ),
        );
      },
      leading: Stack(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(avatarUrl), radius: 24),
          if (isOnline)
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
                  border: Border.all(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(name),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          content!,
          style:
              isSend == 0
                  ? TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                  : TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
