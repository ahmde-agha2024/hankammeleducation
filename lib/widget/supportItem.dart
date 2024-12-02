import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function() onTap;

  SupportItem({required this.onTap, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      leading: Icon(
        icon,
        color: const Color(0xff073b4c),
      ),
      title: Text(
        title,
        style: GoogleFonts.cairo(fontSize: 8, fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Color(0xff073b4c),
        size: 12,
      ),
      onTap: onTap,
    );
  }
}