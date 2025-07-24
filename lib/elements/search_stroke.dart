import 'package:flutter/material.dart';
import 'package:messenger_ui/styles/app_styles.dart';

class SearchStroke extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  SearchStroke({required this.controller, required this.focusNode});

  @override
  State<StatefulWidget> createState() {
    return _SearchStrokeState();
  }
}

class _SearchStrokeState extends State<SearchStroke> {

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
