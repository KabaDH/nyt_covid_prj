import 'package:flutter/cupertino.dart';

buildCard(String description, double data, Color color) {

  return Expanded(
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: 70,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                description,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                data.round().toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ));
}