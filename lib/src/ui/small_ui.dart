import 'package:flutter/material.dart';

Widget buildHeader(String title, [TextStyle style = const TextStyle(fontSize: 24)]) {
  return SliverPadding(
    padding: EdgeInsets.all(10),
    sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Text(title, style: style,),
            Divider(thickness: 2,),
          ],
        )
    ),
  );
}

buildScore(int score) {
  return Wrap(
    spacing: 5,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Icon(Icons.star, color: getColorForScore(score),),
      Text(score.toString(), style: TextStyle(fontWeight: FontWeight.bold),)
    ],
  );
}

Color getColorForScore(int score) {
  var map = <int, Color> {
    0 : Colors.grey[600]!,
    1 : Colors.red,
    2 : Colors.orangeAccent,
    3 : Colors.yellow,
    4 : Colors.lightGreen,
    5 : Colors.green,
  };
  return map[score] ?? map[0]!;
}

SnackBar showBar(String content , Duration duration)
{
  return SnackBar(
    content: Text(content),
    duration: duration,

    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}