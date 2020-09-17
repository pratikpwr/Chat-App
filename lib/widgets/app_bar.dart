import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget myAppBar(BuildContext context) {
  return AppBar(
    title: Text(
      'Chat App',
      style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
    ),
  );
}
