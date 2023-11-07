import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:image_parts_click/src/domain/svg_parser.dart';

class MapSvgPaths {
  double get height => heightSvg;
  double get width => widthSvg;
  String svgPath = "assets/images/hatchback_left.svg";
  List<Path> paths = [];
  double heightSvg = 0;
  double widthSvg = 0;

  Future<void> parseSvgToPath() async {
    SvgParser parser = SvgParser();
    parser.loadFromFile(svgPath).then((value) {
      paths = parser.getPaths();
      heightSvg = parser.svgHeight!;
      widthSvg = parser.svgWidth!;
    });
  }

  Path getPath(idx) => paths[idx];
}
