import 'package:flutter/material.dart';

class ListSearchWidget extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    return _ListSearchWidgetState();
  }
}

class _ListSearchWidgetState extends State<ListSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown,
      child: Column(
        children: [
          Center(child: Text('содержимое ListSearchWidget'),)
        ],
      ),
    );
  }
}