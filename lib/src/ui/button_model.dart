import 'package:flutter/material.dart';
import 'constants.dart';

Widget buildModelButton(String text, Color color, VoidCallback callback, {double fontSize = 18.0}) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(color),
      shape: MaterialStateProperty.resolveWith((Set states) {
        if (states.contains(MaterialState.pressed)) {
          return RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0));
        }
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0));
      }),
      elevation: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return 0.5;
        }
        return 2.0;
      })
    ),
    onPressed: callback,
    child: Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: _getTextColor(color.computeLuminance()),
        fontWeight: FontWeight.w500
      ),
    ),
  );
}

Color _getTextColor(double luminance) => luminance > 0.3 ? CommonColors.themeColorBlack : CommonColors.themeColorPlatinumLight;
