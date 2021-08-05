import 'package:flutter/material.dart';
import 'constants.dart';

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

Widget buildScore(int score) {
  return Wrap(
    spacing: 5,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Icon(Icons.star, color: getColorForScore(score),),
      Text(score.toString(), style: TextStyle(fontWeight: FontWeight.bold),)
    ],
  );
}

Widget buildScoreFill(double score, {double? fontSize, double? iconSize}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: getColorForScore(score.round())
    ),
    padding: const EdgeInsets.all(2),
    child: Wrap(
      spacing: 5,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(Icons.star_rounded, color: Colors.white, size: iconSize,),
        Text(score.toStringAsFixed(1), style: TextStyle(color: Colors.white, fontSize: fontSize),)
      ],
    ),
  );
}

Widget buildArea(bool isInArea, {bool fill = false, double fontSize = 10}) {
  var color = isInArea ? Colors.green : Colors.red;
  return Container(
    padding: const EdgeInsets.all(2),
    decoration: BoxDecoration(
      border: Border.all(color: color, width: 1),
      borderRadius: BorderRadius.circular(4),
      color: fill ? Colors.white : null,
    ),
    child: Text(isInArea ? Strings.get('in-area')! : Strings.get('not-in-area')!, style: TextStyle(fontSize: fontSize, color: color),),
  );
}

final _colorMap = <int, Color> {
  0 : Colors.grey[600]!,
  1 : Colors.red[800]!,
  2 : Colors.orange[700]!,
  3 : Colors.lime[600]!,
  4 : Colors.green,
  5 : Colors.cyan,
};

Color getColorForScore(int score) => _colorMap[score] ?? _colorMap[0]!;

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

Widget buildTextField(String label, String value) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 0.0),
    child: TextFormField(
      decoration: InputDecoration(
        labelText: label,
      ),
      enabled: false,
      readOnly: true,
      initialValue: value,
    ),
  );
}

Widget buildCommentsCount(int count, {Color? color, double iconSize: 22}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color ?? Colors.grey,
    ),
    padding: const EdgeInsets.all(2),
    child: Wrap(
      spacing: 5,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(Icons.comment, color: Colors.white, size: iconSize,),
        Text(count.toString(), style: TextStyle(color: Colors.white),)
      ],
    ),
  );
}