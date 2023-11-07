import 'package:flutter/material.dart';

class PathClipper extends CustomClipper<Path> {
  final Path path;
  const PathClipper(this.path);

  @override
  Path getClip(Size size) {
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
