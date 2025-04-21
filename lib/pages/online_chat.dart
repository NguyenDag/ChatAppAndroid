import 'package:flutter/material.dart';
import 'package:myapp/pages/friendslist_page.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

late Size mq;

class OnlineChat extends StatefulWidget {
  final String name;
  final String avatarUrl;

  const OnlineChat({super.key, required this.name, required this.avatarUrl});

  @override
  State<StatefulWidget> createState() {
    return MyWidget();
  }
}

class Message {
  final String text;
  final bool isSender;

  Message({required this.text, required this.isSender});
}

class MyWidget extends State<OnlineChat> {
  bool _showEmoji = false;
  final TextEditingController _emojiController = TextEditingController();

  List<Message> messages = [
    Message(text: 'Bạn đang làm gì đó?', isSender: false),
    Message(text: 'Tôi đang trên đường đi học.', isSender: true),
    Message(text: 'Có chuyện gì vậy bạn?', isSender: true),
    Message(text: 'Lát nữa ghé mua cho tôi ít đồ nhé.', isSender: false),
    Message(text: 'Oke bạn', isSender: true),
    Message(
      text: 'moi ngay den truong la 1 ngay vui toi di hoc, co nhieu dieu hay',
      isSender: false,
    ),
    Message(
      text: 'Yêu tổ quốc, yêu đồng bào. Học tập tốt, lao động tốt.',
      isSender: true,
    ),
    Message(text: 'Hihi', isSender: false),
    Message(text: 'Bạn đang làm gì đó?', isSender: false),
    Message(text: 'Tôi đang trên đường đi học.', isSender: true),
    Message(text: 'Có chuyện gì vậy bạn?', isSender: true),
    Message(text: 'Lát nữa ghé mua cho tôi ít đồ nhé.', isSender: false),
    Message(text: 'Oke bạn', isSender: true),
    Message(
      text: 'moi ngay den truong la 1 ngay vui toi di hoc, co nhieu dieu hay',
      isSender: false,
    ),
    Message(
      text: 'Yêu tổ quốc, yêu đồng bào. Học tập tốt, lao động tốt.',
      isSender: true,
    ),
    Message(text: 'Hihi', isSender: false),
  ];

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => FriendsList()),
              (Route<dynamic> route) => false,
            );
          },
        ),

        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.avatarUrl),
                  radius: 24,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                      border: Border.all(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Trực tuyến',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w100,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                physics: BouncingScrollPhysics(),
                itemBuilder:
                    (context, index) => ContentMessage(
                      msg: messages[index],
                      index: index,
                      messages: messages,
                    ),
              ),
            ),
            Divider(height: 1), //kẻ đường chỉ ngang
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus(); //Ẩn bàn phím nếu đang mở
                      setState(() {
                        _showEmoji = !_showEmoji;
                      });
                    },
                    child: Image.asset(
                      'assets/images/emoji_icon.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F6F6),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: TextField(
                        controller: _emojiController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          hintText: 'Nhập tin nhắn...',
                          hintStyle: TextStyle(fontSize: 12),
                          border: InputBorder.none,
                          suffixIcon: Icon(Icons.send),
                          suffixIconColor: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Image.asset(
                    'assets/images/attach.png',
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(width: 8),
                  Image.asset('assets/images/image.png', width: 20, height: 20),
                ],
              ),
            ),

            //Emoji picker
            // Offstage(
            //   offstage: !_showEmoji,
            //   child: SizedBox(
            //     height: _showEmoji ? 250 : 0,
            //     child: EmojiPicker(
            //       onEmojiSelected: (category, emoji) {
            //         _emojiController.text += emoji.emoji;
            //       },
            //       config: Config(
            //         columns: 7,
            //         emojiSizeMax: 32,
            //         verticalSpacing: 0,
            //         horizontalSpacing: 0,
            //         initCategory: Category.SMILEYS,
            //         bgColor: Color(0xFFF2F2F2),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class ContentMessage extends StatelessWidget {
  final Message msg;
  final int index;
  final List<Message> messages;

  const ContentMessage({
    super.key,
    required this.msg,
    required this.index,
    required this.messages,
  });

  bool shouldShowAvatar() {
    if (index == 0) return true;
    final preMessage = messages[index - 1];
    return !(preMessage.isSender == msg.isSender && !msg.isSender);
  }

  bool shouldShowTime() {
    if (index == messages.length - 1) return true;
    final posMessage = messages[index + 1];
    return !(posMessage.isSender == msg.isSender);
  }

  @override
  Widget build(BuildContext context) {
    final showTime = shouldShowTime();
    //nếu tin nhắn đó là của mình gửi
    if (msg.isSender) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          margin: EdgeInsets.only(left: mq.width * 0.2, right: mq.width * 0.05),
          child: Column(
            // alignment: Alignment.centerRight,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xFF20A090),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Text(
                  msg.text,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              showTime
                  ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      '09:25 AM',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w100,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      );
    }

    final showAvatar = shouldShowAvatar();

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        margin: EdgeInsets.only(left: mq.width * 0.04,),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showAvatar
                ? Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://th.bing.com/th/id/OIP.dIF3iIIIuK5HeBCq_aoxZwHaH8?rs=1&pid=ImgDetMain',
                      ),
                      radius: 25,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                          border: Border.all(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
                : SizedBox(width: 50),
            SizedBox(width: mq.width * .03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                showAvatar
                    ? SizedBox(height: mq.height * .01)
                    : SizedBox.shrink(),
                showAvatar
                    ? Text(
                      'Ban X',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    )
                    : SizedBox.shrink(),
                //không hiển thị tên và không chiếm không gian
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: mq.width * 0.65),
                        margin:
                            showAvatar
                                ? EdgeInsets.only(top: mq.height * 0.01)
                                : EdgeInsets.only(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFF2F7FB),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    showTime
                        ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '09:25 AM',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w100,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
