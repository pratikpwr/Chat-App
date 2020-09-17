import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration buildTextDecoration(
  BuildContext context,
  String title,
  IconData icon,
) {
  return InputDecoration(
    /*icon: Icon(
      icon,
      color: Colors.white,
    ),*/
    border: OutlineInputBorder(),
    labelText: title,
    labelStyle: GoogleFonts.poppins(color: Colors.white),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
      ),
      borderRadius: BorderRadius.circular(30.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
      ),
      borderRadius: BorderRadius.circular(30.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.redAccent,
      ),
      borderRadius: BorderRadius.circular(30.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
      ),
      borderRadius: BorderRadius.circular(30.0),
    ),
  );
}
