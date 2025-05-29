import 'package:flutter/material.dart';
import 'package:myapp/models/message.dart';
import 'package:myapp/pages/friendslist_page.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myapp/services/message_service.dart';

import '../services/message_database.dart';

late Size mq;

class OnlineChat extends StatefulWidget {
  final String name;
  final String avatarUrl;
  final String friendId;
  final bool isOnline;

  const OnlineChat({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.friendId,
    required this.isOnline,
  });

  @override
  State<StatefulWidget> createState() {
    return MyWidget();
  }
}

class MyWidget extends State<OnlineChat> {
  final ScrollController _scrollController = ScrollController();

  bool _showEmoji = false;
  final TextEditingController _emojiController = TextEditingController();
  List<Message> messages = [];

  void loadMessage() async {
    List<Message> msg = await MessageService.fetchMessages(widget.friendId);

    for (var m in msg) {
      await MessageDatabase.insertMessage(m); // <- Lưu từng tin nhắn vào SQLite
    }
    setState(() {
      messages = msg;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void loadOfflineMessages() async {
    List<Message> cached = await MessageDatabase.getMessages(widget.friendId);
    setState(() {
      messages = cached;
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    loadOfflineMessages();
    loadMessage();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                if (widget.isOnline)
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
                  widget.isOnline
                      ? Text(
                        'Trực tuyến',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w100,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                      : Text(
                        'Offline',
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
                controller: _scrollController,
                itemCount: messages.length,
                // physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final prevMsg = index > 0 ? messages[index - 1] : null;

                  final currentDate = formatDateGroup(msg.createdAt);
                  final prevDate =
                      prevMsg != null ? formatDateGroup(prevMsg.createdAt) : '';

                  bool showDateHeader = currentDate != prevDate;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (showDateHeader)
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF8F8FB),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 3,
                              ),
                              child: Text(
                                currentDate,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ContentMessage(
                        msg: messages[index],
                        index: index,
                        name: widget.name,
                        messages: messages,
                        avatarUrl: widget.avatarUrl,
                        isOnline: widget.isOnline,
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
                      height: null,
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F6F6),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: TextField(
                        controller: _emojiController,
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          hintText: 'Nhập tin nhắn...',
                          hintStyle: TextStyle(fontSize: 12),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            color: Colors.blue,
                            onPressed: () async {
                              if (_emojiController.text.trim().isEmpty) return;

                              final newMsg = await MessageService.sendMessage(
                                friendId: widget.friendId,
                                content: _emojiController.text.trim(),
                              );

                              if (newMsg != null) {
                                await MessageDatabase.insertMessage(newMsg);
                                setState(() {
                                  messages.add(newMsg);
                                  _emojiController.clear();
                                });
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  _scrollToBottom();
                                });
                              }
                            },
                          ),
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
    final diff = Message.formatDate(now).difference(Message.formatDate(date)).inDays;

    if (diff == 0) return 'Hôm nay';
    if (diff == 1) return 'Hôm qua';
    return DateFormat('dd/MM/yyyy').format(date);
  }
}

class ContentMessage extends StatelessWidget {
  final Message msg;
  final int index;
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final List<Message> messages;

  const ContentMessage({
    super.key,
    required this.msg,
    required this.index,
    required this.name,
    required this.avatarUrl,
    required this.messages,
    required this.isOnline,
  });

  bool get _showAvatar =>
      index == 0 ||
      !(messages[index - 1].messageType == msg.messageType &&
          msg.messageType == 0);

  bool get _showTime =>
      index == messages.length - 1 ||
      !(messages[index + 1].messageType == msg.messageType) ||
      !(Message.formatDate(messages[index + 1].createdAt) == Message.formatDate(msg.createdAt));

  @override
  Widget build(BuildContext context) {
    if (msg.messageType == 1) {
      return _buildSenderMessage();
    }
    return _buildReceiverMessage(name, avatarUrl, isOnline);
  }

  Widget _buildSenderMessage() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        margin: EdgeInsets.only(left: mq.width * 0.2, right: mq.width * 0.01),
        child: Column(
          // alignment: Alignment.centerRight,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFF20A090),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Text(
                msg.content!,
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
                  DateFormat('hh:mm a').format(msg.createdAt),
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

  Widget _buildReceiverMessage(String name, String avatarUrl, bool isOnline) =>
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _showAvatar
                ? Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(avatarUrl),
                      radius: 25,
                    ),
                    if (isOnline)
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
                    name,
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
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
                          msg.content!,
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
                          DateFormat('hh:mm a').format(msg.createdAt),
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
