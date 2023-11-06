///
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:image_parts_click/parser.dart';

class MapSvgData {
  static double get height => heightSvg;
  static double get width => widthSvg;
  static const svgPath = "assets/images/hatchback_left.svg";
  static List<Path> paths = [];
  static double heightSvg = 0;
  static double widthSvg = 0;
  static void parseSvgToPath() {
    SvgParser parser = SvgParser();
    parser.loadFromFile(svgPath).then((value) {
      paths = parser.getPaths();
      heightSvg = parser.svgHeight!;
      widthSvg = parser.svgWidth!;
    });
  }

  static Path getPath(idx) => paths[idx];
}
