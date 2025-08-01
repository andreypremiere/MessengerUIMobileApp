import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:messenger_ui/styles/app_styles.dart';
import 'package:messenger_ui/utils/stdout_message.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  late var chat;
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    chat = args['chat'];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    const List messages = [
      {'id': 0, 'message': 'Hello world1'},
      {
        'id': 1,
        'message': 'Hello world2 jlkfjs lkjds lksjdlf lskjfkj lksjdfl dsklj',
      },
      {'id': 0, 'message': 'Hello world3'},
      {'id': 0, 'message': 'Hello world4'},
      {'id': 1, 'message': 'Hello world5'},
      {'id': 0, 'message': 'Hello world6'},
      {'id': 1, 'message': 'Hello world7'},
      {'id': 1, 'message': 'Hello world8'},
      {'id': 0, 'message': 'Hello world9'},
      {'id': 0, 'message': 'Hello world10'},
      {'id': 0, 'message': 'Hello world1'},
      {
        'id': 1,
        'message': 'Hello world2 jlkfjs lkjds lksjdlf lskjfkj lksjdfl dsklj',
      },
      {'id': 0, 'message': 'Hello world3'},
      {'id': 0, 'message': 'Hello world4'},
      {'id': 1, 'message': 'Hello world5'},
      {'id': 0, 'message': 'Hello world6'},
      {'id': 1, 'message': 'Hello world7'},
      {'id': 1, 'message': 'Hello world8'},
      {'id': 0, 'message': 'Hello world9'},
      {'id': 0, 'message': 'Hello world10'},
    ];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          color: AppColors.mainBackground,
          child: SafeArea(
            child: Column(
              children: [
                // AppBar
                Container(
                  height: 64,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/arrow_back.svg',
                            width: 32,
                            height: 32,
                            color: AppColors.iconGray,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            printColorMessage('Нажат профиль пользователя');
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    // color: Colors.blueAccent,
                                    fit: BoxFit.fitHeight,
                                    width: 48,
                                    height: 48,
                                    imageUrl:
                                        "https://avatars.mds.yandex.net/get-mpic/5366523/2a0000018c2905e8ad28c089c633138c8e02/orig",
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        chat?.name,
                                        style: TextStyle(
                                          color: AppColors.textBlack,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.mainBackgroundChat,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: messages.map((message) {
                          return message['id'] == 1
                              ? MessageFromMe(message: message['message'])
                              : MessageFromOther(message: message['message']);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Container(
                  // height: 64,
                  color: AppColors.mainBackgroundChat,
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Сообщение',
                              border: InputBorder.none,
                            ),
                            minLines: 1,
                            maxLines: 5,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textBlack,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      Container(
                        // padding: EdgeInsets.all(-2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/icons/send_message.svg',
                            width: 32,
                            height: 32,
                            color: AppColors.iconGray,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageFromMe extends StatelessWidget {
  String message;

  MessageFromMe({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 280),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFC7F3FF),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(12),
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.textBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MessageFromOther extends StatelessWidget {
  String message;

  MessageFromOther({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 280),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(12),
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.textBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
