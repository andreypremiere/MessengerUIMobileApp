import 'package:flutter/material.dart';

class AppColors {
  static const Color mainBackground = Color(0xFFF5FCFF);
  static const Color mainButton = Color(0xFF00A6FF);
  static const Color mainBlueIcon = Color(0xFFABE2FF);
  static const Color mainBackgroundChat = Color.fromARGB(255, 190, 229, 250);
  static const Color messageBackground = Color(0xFFD7F7FF);
  static const Color borderInput = Color(0xFFD2D2D2);
  static const Color textBlack = Color(0xFF3F3F3F);
  static const Color iconGray = Color(0xFF9A9A9A);
}

class BoxDecorationForm {
  static final BoxDecoration formDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.10),
        blurRadius: 10,
        offset: Offset(0, 0),
      ),
    ],
  );
}

class AppInputStyles {
  static InputDecoration inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Color(0xFFD2D2D2), // border-input-color
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Color(0xFF888888), // активный бордер
          width: 2,
        ),
      ),
      contentPadding: EdgeInsets.all(10),
    );
  }
}

class AppButtonStyle {
  static final ButtonStyle styleButton = ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF00A6FF),
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // скругление углов
    ),
  );
}
