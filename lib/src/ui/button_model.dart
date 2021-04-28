import 'package:flutter/material.dart';
import 'constants.dart';

Widget buildModelButton(String text, Color color, VoidCallback callback) {
  return ElevatedButton(
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            )
        )
    ),
    onPressed: callback,
    child: Text(
      text,
      style: TextStyle(
          fontSize: 20,
          color: CommonColors.black
      ),
    ),
  );
}
