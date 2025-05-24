import 'package:flutter/material.dart';
import 'package:myapp/pages/friendslist_page.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:intl/intl.dart';

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
  final DateTime createAt;

  Message({required this.text, required this.isSender, required this.createAt});

  // Message({required this.text, required this.isSender});
}

class MyWidget extends State<OnlineChat> {
  bool _showEmoji = false;
  final TextEditingController _emojiController = TextEditingController();

  List<Message> messages = [
    Message(
      text: 'Bạn đang làm gì đó?',
      isSender: false,
      createAt: DateTime.now().subtract(Duration(days: 2, hours: 3)),
    ),
    Message(
      text: 'Tôi đang trên đường đi học.',
      isSender: true,
      createAt: DateTime.now().subtract(Duration(days: 2, hours: 3)),
    ),
    Message(
      text: 'Có chuyện gì vậy bạn?',
      isSender: true,
      createAt: DateTime.now().subtract(Duration(days: 1, hours: 5)),
    ),
    Message(
      text: 'Lát nữa ghé mua cho tôi ít đồ nhé.',
      isSender: false,
      createAt: DateTime.now().subtract(Duration(minutes: 4)),
    ),
    Message(
      text: 'Oke bạn',
      isSender: true,
      createAt: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    Message(
      text: 'moi ngay den truong la 1 ngay vui toi di hoc, co nhieu dieu hay',
      isSender: false,
      createAt: DateTime.now().subtract(Duration(minutes: 6)),
    ),
    Message(
      text: 'Yêu tổ quốc, yêu đồng bào. Học tập tốt, lao động tốt.',
      isSender: true,
      createAt: DateTime.now().subtract(Duration(minutes: 7)),
    ),
    Message(
      text: 'Hihi',
      isSender: false,
      createAt: DateTime.now().subtract(Duration(minutes: 8)),
    ),
    // Thêm các tin nhắn tiếp theo tương tự
  ];

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
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
        padding: const EdgeInsets.only(),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                // physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final prevMsg = index > 0 ? messages[index - 1] : null;

                  final currentDate = formatDateGroup(msg.createAt);
                  final prevDate =
                      prevMsg != null ? formatDateGroup(prevMsg.createAt) : '';

                  bool showDateHeader = currentDate != prevDate;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showDateHeader)
                        Center(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                              child: Text(
                                currentDate,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            color: Colors.grey,
                          ),
                        ),
                      ContentMessage(
                        msg: messages[index],
                        index: index,
                        messages: messages,
                      ),
                    ],
                  );
                },
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
                      FocusScope.of(
                        context,
                      ).unfocus(); //Ẩn bàn phím nếu đang mở
                      // showEmojiKeyboard = !showEmojiKeyboard;
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
            Offstage(
              offstage: !_showEmoji,
              child: SizedBox(
                height: _showEmoji ? 250 : 0,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    _emojiController.text += emoji.emoji;
                  },
                  config: Config(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDateGroup(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    if (diff == 0) return 'Hôm nay';
    if (diff == 1) return 'Hôm qua';
    return DateFormat('dd/MM/yyyy').format(date);
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

  bool get _showAvatar =>
      index == 0 ||
      !(messages[index - 1].isSender == msg.isSender && !msg.isSender);

  bool get _showTime =>
      index == messages.length - 1 ||
      !(messages[index + 1].isSender == msg.isSender);

  @override
  Widget build(BuildContext context) {
    if (msg.isSender) {
      return _buildSenderMessage();
    }
    return _buildReceiverMessage();
  }

  Widget _buildSenderMessage() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        margin: EdgeInsets.only(left: mq.width * 0.2, right: mq.width * 0.01),
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
            if (_showTime)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  DateFormat('HH:mm').format(msg.createAt),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w100,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiverMessage() => Padding(
    padding: const EdgeInsets.all(5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _showAvatar
            ? Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/nguyen-dang.appspot.com/o/em.jpg?alt=media&token=218bdcd8-e29b-46d8-a516-4cc4ad8c1776',
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
        SizedBox(width: mq.width * 0.03),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_showAvatar) SizedBox(height: mq.height * 0.01),
            if (_showAvatar)
              Text(
                'Ban X',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: mq.width * 0.65),
                    margin:
                        _showAvatar
                            ? EdgeInsets.only(top: mq.height * 0.01)
                            : EdgeInsets.only(),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                if (_showTime)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      DateFormat('HH:mm').format(msg.createAt),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w100,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
