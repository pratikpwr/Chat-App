import 'package:flutter/material.dart';

Container buttonContainer({BuildContext context, Color color, Widget child}) {
  return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: child);
}
