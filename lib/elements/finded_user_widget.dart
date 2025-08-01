import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messenger_ui/models/chat.dart';

class FindedUserWidget extends StatefulWidget {
  late var user;

  FindedUserWidget({required this.user});


  @override
  State<StatefulWidget> createState() {
    return _FindedUserWidget();
  }
}

class _FindedUserWidget extends State<FindedUserWidget> {
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/chat_page',
        // arguments: {
        //   'chat': widget.chat
        // });
      },
      child: Container(
        decoration: BoxDecoration(
          // color: const Color.fromARGB(255, 244, 252, 255),
          // borderRadius: BorderRadius.circular(12),
          border: Border(
            bottom: BorderSide(
              color: const Color.fromARGB(255, 234, 234, 234), // Цвет линии
              width: 1.0, // Толщина линии
            ),
          ),
        ),
        // height: 64,
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                // color: Colors.blueAccent,
                fit: BoxFit.fitHeight,
                width: 54,
                height: 54,
                imageUrl:
                    "https://avatars.mds.yandex.net/get-mpic/5366523/2a0000018c2905e8ad28c089c633138c8e02/orig",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(width: 10),
            Text(
              widget.user?.displayedNickname,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
