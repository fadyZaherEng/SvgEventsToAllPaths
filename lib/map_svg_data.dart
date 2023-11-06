///
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:image_parts_click/parser.dart';

enum Province {
  noordBrabant,
  utrecht,
  zuidHolland,
  noordHolland,
  drenthe,
  friesland,
}

Path getPathByProvince(Province province) {
  switch (province) {
    case Province.noordBrabant:
      return MapSvgData.noordBrabant;
    case Province.utrecht:
      return MapSvgData.utrecht;
    case Province.zuidHolland:
      return MapSvgData.zuidHolland;
    case Province.noordHolland:
      return MapSvgData.noordHolland;
    case Province.drenthe:
      return MapSvgData.drenthe;
    case Province.friesland:
      return MapSvgData.friesland;
  }
}

class MapSvgData {
  /// Height and width of the used SVG image
  static double get height => heightSvg;
  static double get width => widthSvg;
  static const svgPath = "assets/images/test.svg";
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

  static Path get noordBrabant => paths[0];
  static Path get utrecht => paths[1];
  static Path get zuidHolland => paths[2];
  static Path get noordHolland => paths[3];
  static Path get drenthe => paths[4];
  static Path get friesland => paths[5];
}
