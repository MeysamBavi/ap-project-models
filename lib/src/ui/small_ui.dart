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