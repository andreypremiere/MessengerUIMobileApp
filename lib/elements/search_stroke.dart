import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messenger_ui/styles/app_styles.dart';


class SearchStroke extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function searchUsers;
  final List findedUsers;

  SearchStroke({
    required this.controller,
    required this.focusNode,
    required this.searchUsers,
    required this.findedUsers
  });

  @override
  State<StatefulWidget> createState() {
    return _SearchStrokeState();
  }
}

class _SearchStrokeState extends State<SearchStroke> {
  Timer? _debounce;

  void _search() {
    if (widget.controller.text.trim().isEmpty) {
      widget.findedUsers.clear();
      return;
    }
    else {
      widget.searchUsers();
    }
  }

  void onTextChanged() {
  _debounce?.cancel();

  _debounce = Timer(const Duration(seconds: 1), () {
   _search();
  });
}

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(left: 0, top: 8, right: 8, bottom: 8),
      decoration: BoxDecoration(
        // color: const Color.fromARGB(255, 254, 213, 213),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            blurRadius: 8,
            offset: Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onChanged: (value) {
          // widget.searchUsers();
          onTextChanged();
        },
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: TextStyle(
          fontSize: 16,
          color: AppColors.textBlack,
          fontFamily: 'Inter',
        ),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Поиск',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
