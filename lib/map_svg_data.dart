///
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:image_parts_click/parser.dart';

// enum Province {
//   noordBrabant,
//   utrecht,
//   zuidHolland,
//   noordHolland,
//   drenthe,
//   friesland,
//   friesland1,
//   friesland2,
//   friesland3,
//   friesland4,
//   friesland5,
//   friesland6,
//   friesland7,
//   friesland8,
//   friesland9,
//   friesland10,
//   friesland11,
// }
//
// Path getPathByProvince(Province province) {
//   switch (province) {
//     case Province.noordBrabant:
//       return MapSvgData.noordBrabant;
//     case Province.utrecht:
//       return MapSvgData.utrecht;
//     case Province.zuidHolland:
//       return MapSvgData.zuidHolland;
//     case Province.noordHolland:
//       return MapSvgData.noordHolland;
//     case Province.drenthe:
//       return MapSvgData.drenthe;
//     case Province.friesland:
//       return MapSvgData.friesland;
//
//     case Province.friesland1:
//       return MapSvgData.friesland1;
//     case Province.friesland2:
//       return MapSvgData.friesland2;
//     case Province.friesland3:
//       return MapSvgData.friesland3;
//     case Province.friesland4:
//       return MapSvgData.friesland4;
//     case Province.friesland5:
//       return MapSvgData.friesland5;
//     case Province.friesland6:
//       return MapSvgData.friesland6;
//     case Province.friesland7:
//       return MapSvgData.friesland7;
//     case Province.friesland8:
//       return MapSvgData.friesland8;
//     case Province.friesland9:
//       return MapSvgData.friesland9;
//     case Province.friesland10:
//       return MapSvgData.friesland10;
//     case Province.friesland11:
//       return MapSvgData.friesland11;
//   }
// }

class MapSvgData {
  /// Height and width of the used SVG image
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
