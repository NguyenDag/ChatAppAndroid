import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/image_model.dart';
import 'package:myapp/models/message.dart';
import 'package:myapp/pages/friendslist_page.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myapp/services/message_service.dart';

import '../constants/api_constants.dart';
import '../models/file_model.dart';
import '../services/file_service.dart';
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

  // File? _pickedImage;

  List<File> _pickedImages = [];
  List<File> _pickedFiles = [];

  final ImagePicker _imagePicker = ImagePicker();
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

            if (_pickedImages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _pickedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _pickedImages[index],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _pickedImages.removeAt(index);
                              });
                            },
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.close,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

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
                              final hasText =
                                  _emojiController.text.trim().isNotEmpty;
                              final hasImage = _pickedImages.isNotEmpty;
                              final hasFiles = _pickedFiles.isNotEmpty;

                              if (!hasText && !hasImage && !hasFiles) return;

                              final newMsg = await MessageService.sendMessage(
                                friendId: widget.friendId,
                                content: _emojiController.text.trim(),
                                imageFiles: hasImage ? _pickedImages : null,
                                otherFiles: hasFiles ? _pickedFiles : null,
                              );

                              if (newMsg != null) {
                                await MessageDatabase.insertMessage(newMsg);
                                setState(() {
                                  messages.add(newMsg);
                                  _emojiController.clear();
                                  _pickedImages.clear(); // reset sau khi gửi
                                  _pickedFiles.clear(); // reset sau khi gửi
                                });

                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
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
                  GestureDetector(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(allowMultiple: true);
                      if (result != null) {
                        setState(() {
                          _pickedFiles =
                              result.paths.map((p) => File(p!)).toList();
                        });
                      }
                    },
                    child: Image.asset(
                      'assets/images/attach.png',
                      width: 20,
                      height: 20,
                    ),
                  ),

                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      final List<XFile> images =
                          await _imagePicker.pickMultiImage();
                      if (images != null && images.isNotEmpty) {
                        setState(() {
                          _pickedImages =
                              images.map((x) => File(x.path)).toList();
                        });
                      }
                    },
                    child: Image.asset(
                      'assets/images/image.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
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
    final diff =
        Message.formatDate(now).difference(Message.formatDate(date)).inDays;

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
      !(Message.formatDate(messages[index + 1].createdAt) ==
          Message.formatDate(msg.createdAt));

  @override
  Widget build(BuildContext context) {
    if (msg.messageType == 1) {
      return _buildSenderMessage();
    }
    return _buildReceiverMessage(name, avatarUrl, isOnline);
  }

  Widget _buildSenderMessage() {
    final Widget senderMessageBody;

    if (msg.images != null && msg.images!.isNotEmpty) {
      senderMessageBody = _ImageMessages(
        images: msg.images!,
        createdAt: msg.createdAt,
        showTime: _showTime,
        messageType: msg.messageType,
      );
    } else if (msg.files != null && msg.files!.isNotEmpty) {
      senderMessageBody = _FileMessages(
        files: msg.files!,
        createdAt: msg.createdAt,
        showTime: _showTime,
        messageType: msg.messageType,
      );
    } else {
      senderMessageBody = _TextMessage(
        content: msg.content ?? '',
        createdAt: msg.createdAt,
        showTime: _showTime,
        showAvatar: _showAvatar,
        messageType: msg.messageType,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        margin: EdgeInsets.only(left: mq.width * 0.2, right: mq.width * 0.01),
        child: Column(
          // alignment: Alignment.centerRight,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            senderMessageBody,
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

  Widget _buildReceiverMessage(String name, String avatarUrl, bool isOnline) {
    final Widget receiverMessageBody;

    if (msg.images != null && msg.images!.isNotEmpty) {
      receiverMessageBody = _ImageMessages(
        images: msg.images!,
        createdAt: msg.createdAt,
        showTime: _showTime,
        messageType: msg.messageType,
      );
    } else if (msg.files != null && msg.files!.isNotEmpty) {
      receiverMessageBody = _FileMessages(
        files: msg.files!,
        createdAt: msg.createdAt,
        showTime: _showTime,
        messageType: msg.messageType,
      );
    } else {
      receiverMessageBody = _TextMessage(
        content: msg.content ?? '',
        createdAt: msg.createdAt,
        showTime: _showTime,
        showAvatar: _showAvatar,
        messageType: msg.messageType,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _showAvatar
              ? Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                    radius: 20,
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
              : SizedBox(width: 40),
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
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 60),
                    child: receiverMessageBody,
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
}

class _ImageMessages extends StatelessWidget {
  final List<ImageModel> images;
  final DateTime createdAt;
  final bool showTime;
  final int messageType;

  const _ImageMessages({
    required this.images,
    required this.createdAt,
    required this.showTime,
    required this.messageType,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    Widget imageWidget;
    if (images.length == 1) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          ApiConstants.getUrl(images[0].urlImage),
          width: mq.width * 0.65,
          height: mq.height * 0.65 * 3 / 4,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => Container(
                color: Colors.white,
                width: mq.width * 0.65,
                height: mq.height * 0.65 * 3 / 4,
                child: Icon(Icons.broken_image),
              ),
        ),
      );
    } else if (images.length == 2) {
      double itemWidth = (mq.width * 0.65 - 6) / 2;
      double itemHeight = itemWidth * 3 / 4;

      imageWidget = Container(
        width: mq.width * 0.67,
        child: Row(
          mainAxisAlignment:
              messageType == 1
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children:
              images.map((image) {
                return Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      ApiConstants.getUrl(image.urlImage),
                      width: itemWidth,
                      height: itemHeight,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            width: itemWidth,
                            height: itemHeight,
                            child: Icon(Icons.broken_image),
                          ),
                    ),
                  ),
                );
              }).toList(),
        ),
      );
    } else {
      imageWidget = Container(
        width: mq.width * 0.65,
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children:
              images.map((image) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    ApiConstants.getUrl(image.urlImage),
                    width: (mq.width * 0.65 - 12) / 3,
                    height: mq.height * 0.15,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          width: (mq.width * 0.65 - 12) / 3,
                          height: mq.height * 0.15,
                          child: Icon(Icons.broken_image),
                        ),
                  ),
                );
              }).toList(),
        ),
      );
    }
    ;

    return imageWidget;
  }
}

class _FileMessages extends StatelessWidget {
  final List<FileModel> files;
  final DateTime createdAt;
  final bool showTime;
  final int messageType;

  const _FileMessages({
    required this.files,
    required this.createdAt,
    required this.showTime,
    required this.messageType,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      constraints: BoxConstraints(maxWidth: mq.width * 0.65),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            files.map((file) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.insert_drive_file, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        file.fileName ?? 'File',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        _downloadFile(context, file.urlFile, file.fileName);
                      },
                      child: const Icon(
                        Icons.download,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  void _downloadFile(
    BuildContext context,
    String? url,
    String? fileName,
  ) async {
    if (url == null || fileName == null) return;

    FileService.downloadToDownloadFolder(url, fileName);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đang tải $fileName...')));
  }
}

class _TextMessage extends StatelessWidget {
  final String content;
  final DateTime createdAt;
  final bool showTime;
  final bool showAvatar;
  final int messageType;

  const _TextMessage({
    required this.content,
    required this.createdAt,
    required this.showTime,
    required this.showAvatar,
    required this.messageType,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    Widget textMessage = Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin:
          (messageType == 0 && showAvatar)
              ? EdgeInsets.only(top: mq.height * 0.01)
              : EdgeInsets.only(),

      decoration: BoxDecoration(
        color: messageType == 1 ? Color(0xFF20A090) : Color(0xFFF2F7FB),
        borderRadius:
            messageType == 1
                ? BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                )
                : BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: mq.width * 0.6),
        child: Text(
          content,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: messageType == 1 ? Colors.white : Colors.black,
          ),
        ),
      ),
    );

    return textMessage;
  }
}
